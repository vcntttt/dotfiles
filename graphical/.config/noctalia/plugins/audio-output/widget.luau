local headphones_sink = "alsa_output.usb-Kingston_Technology_Company_HyperX_Cloud_Flight_Wireless-00.analog-stereo"

local sink = ""
local volume = 0
local muted = false
local refresh_pending = false
local refresh_again = false

local function glyph()
  if muted or volume == 0 then
    return "volume-off"
  end

  if string.find(sink, headphones_sink, 1, true) then
    return "headphones"
  end

  if string.find(sink, "hdmi", 1, true) then
    return "device-tv"
  end

  if volume <= 33 then
    return "volume"
  end

  if volume <= 66 then
    return "volume-2"
  end

  return "volume-3"
end

local function render()
  barWidget.setGlyph(glyph())
  barWidget.setText(tostring(volume) .. "%")
end

local function update_audio(result)
  if result.exitCode ~= 0 then
    return
  end

  sink = string.match(result.stdout, "^([^\n]+)") or sink
  volume = tonumber(string.match(result.stdout, "Volume:.-(%d+)%%")) or volume
  muted = string.find(result.stdout, "Mute:%s+yes", 1, false) ~= nil
  render()
end

local function refresh()
  if refresh_pending then
    refresh_again = true
    return
  end

  refresh_pending = true
  noctalia.runAsync(
    "pactl get-default-sink; pactl get-sink-volume @DEFAULT_SINK@; pactl get-sink-mute @DEFAULT_SINK@",
    function(result)
      refresh_pending = false
      update_audio(result)

      if refresh_again then
        refresh_again = false
        refresh()
      end
    end
  )
end

local subscription = noctalia.runStream("pactl subscribe", function(line)
  if string.find(line, "on sink", 1, true) or string.find(line, "on server", 1, true) then
    refresh()
  end
end)

function onExit()
  if subscription then
    subscription.stop()
  end
end

refresh()
