local displays = {}
local loading = true
local refreshing = false
local error_message = nil
local sync_brightness = false
local monitor_rotate = noctalia.expandPath("~/.local/bin/monitor-rotate")
local ddc_displays = nil
local ddc_discovery_pending = false
local ddc_discovery_waiters = {}

local function shell_quote(value)
  return "'" .. string.gsub(value, "'", "'\\''") .. "'"
end

local function render()
  local children = {
    ui.row({ align = "center", gap = 8 }, {
      ui.label({
        text = "Pantallas",
        fontSize = 20,
        fontWeight = "bold",
        color = "primary",
        flexGrow = 1,
      }),
      ui.row({ align = "center", gap = 6 }, {
        ui.label({ text = "Sincronizar brillo", color = "on_surface_variant" }),
        ui.toggle({ checked = sync_brightness, onChange = "toggle_sync_brightness" }),
      }),
      ui.button({ glyph = "refresh", tooltip = "Actualizar", variant = "ghost", onClick = "refresh" }),
      ui.button({ glyph = "close", tooltip = "Cerrar", variant = "ghost", onClick = "close_panel" }),
    }),
  }

  if loading then
    table.insert(children, ui.label({ text = "Detectando pantallas…", color = "on_surface_variant" }))
  elseif error_message ~= nil then
    table.insert(children, ui.column({
      fill = "error/0.12",
      radius = 12,
      padding = 14,
      gap = 6,
    }, {
      ui.label({ text = "No se pudieron consultar las pantallas", fontWeight = "bold", color = "error" }),
      ui.label({ text = error_message, color = "on_surface_variant" }),
    }))
  elseif #displays == 0 then
    table.insert(children, ui.label({ text = "No hay pantallas activas", color = "on_surface_variant" }))
  else
    for _, display in ipairs(displays) do
      local brightness = display.pending_brightness or display.brightness
      local brightness_available = brightness ~= nil
      local brightness_value = brightness_available and brightness / 100 or 0
      local resolution = string.format("%dx%d", display.width or 0, display.height or 0)
      local scale = math.floor(((display.scale or 1) * 100) + 0.5)
      local title = (display.description or display.name) .. " (" .. display.name .. ")"
      local display_id = display.name

      local rotation_buttons = {}
      for _, rotation in ipairs({0, 1, 2, 3}) do
        local selected = display.transform == rotation
        table.insert(rotation_buttons, ui.button({
          key = display_id .. ":rotation:" .. tostring(rotation),
          text = ({[0] = "0°", [1] = "90°", [2] = "180°", [3] = "270°"})[rotation],
          variant = selected and "primary" or "outline",
          controlSize = "sm",
          selected = selected,
          tooltip = "Aplicar rotación " .. tostring(rotation * 90) .. "°",
          onClick = function()
            rotate(display_id, rotation)
          end,
        }))
      end
      local rotation_row_children = {
        ui.glyph({ name = "screen-share", size = 18, color = "on_surface_variant" }),
        ui.label({ text = "Orientación", color = "on_surface_variant", flexGrow = 1 }),
      }
      for _, button in ipairs(rotation_buttons) do
        table.insert(rotation_row_children, button)
      end

      table.insert(children, ui.column({
        key = display_id,
        fill = "surface_variant/0.55",
        border = "outline/0.35",
        borderWidth = 1,
        radius = 14,
        padding = 16,
        gap = 10,
      }, {
        ui.row({ align = "center", gap = 8 }, {
          ui.glyph({ name = "device-desktop", size = 20, color = "on_surface" }),
          ui.label({ text = title, fontSize = 16, fontWeight = "bold", color = "on_surface", flexGrow = 1 }),
        }),
        ui.label({ text = resolution .. " @ " .. tostring(scale) .. "%", color = "on_surface_variant" }),
        ui.row({ align = "center", gap = 8 }, {
          ui.glyph({ name = "brightness-low", size = 18, color = "on_surface_variant" }),
          ui.slider({
            key = display_id .. ":brightness",
            min = 0.1,
            max = 1.0,
            step = 0.01,
            value = brightness_value,
            enabled = brightness_available,
            flexGrow = 1,
            onChange = function(value)
              display.pending_brightness = math.floor((tonumber(value) or brightness_value) * 100 + 0.5)
              render()
            end,
            onDragEnd = function()
              local pending = display.pending_brightness or display.brightness
              if pending ~= nil then
                set_brightness(display_id, pending / 100)
              end
            end,
          }),
          ui.glyph({ name = "brightness-high", size = 18, color = "on_surface_variant" }),
          ui.label({
            text = brightness_available and (tostring(math.floor(brightness + 0.5)) .. "%") or "No disponible",
            color = brightness_available and "on_surface_variant" or "error",
          }),
        }),
        ui.row({ align = "center", gap = 8 }, rotation_row_children),
      }))
    end
  end

  panel.render(ui.column({ gap = 14, padding = 4 }, children))
end

local function parse_ddc_displays(output)
  local result = {}
  local current = nil
  local bus = nil

  for line in string.gmatch(output, "[^\r\n]+") do
    local number = string.match(line, "^Display%s+(%d+)")
    if number ~= nil then
      current = tonumber(number)
      bus = nil
    else
      local bus_number = string.match(line, "I2C bus:%s+/dev/i2c%-(%d+)")
      if bus_number ~= nil then
        bus = tonumber(bus_number)
      end

      local connector = string.match(line, "DRM[_ ]connector:%s+card%d+%-(.+)")
      if connector ~= nil and current ~= nil and bus ~= nil then
        result[connector] = {
          display = current,
          bus = bus,
        }
      end
    end
  end

  return result
end

local function discover_ddc_displays(callback)
  if ddc_displays ~= nil then
    callback(ddc_displays)
    return
  end

  table.insert(ddc_discovery_waiters, callback)
  if ddc_discovery_pending then
    return
  end

  ddc_discovery_pending = true
  noctalia.runAsync("ddcutil detect", function(result)
    if result.exitCode == 0 then
      ddc_displays = parse_ddc_displays(result.stdout)
    end

    ddc_discovery_pending = false
    local waiters = ddc_discovery_waiters
    ddc_discovery_waiters = {}
    for _, waiter in ipairs(waiters) do
      waiter(ddc_displays or {})
    end
  end)
end

local function refresh_brightness()
  discover_ddc_displays(function(known_displays)
    local pending_reads = 0

    for _, display in ipairs(displays) do
      display.brightness = nil
      local ddc_display = known_displays[display.name]
      display.ddc_bus = ddc_display ~= nil and ddc_display.bus or nil
      if display.ddc_bus ~= nil then
        pending_reads = pending_reads + 1
      end
    end

    if pending_reads == 0 then
      refreshing = false
      render()
      return
    end

    for _, display in ipairs(displays) do
      if display.ddc_bus ~= nil then
        noctalia.runAsync("ddcutil --bus " .. tostring(display.ddc_bus) .. " getvcp 10", function(result)
        local value = string.match(result.stdout, "current value%s*=%s*(%d+)")
        display.brightness = value ~= nil and tonumber(value) or nil
        display.pending_brightness = nil
        render()
          pending_reads = pending_reads - 1
          if pending_reads == 0 then
            refreshing = false
            render()
          end
        end)
      end
    end
  end)
end

function refresh()
  if refreshing then
    return
  end

  refreshing = true
  loading = true
  error_message = nil
  render()

  noctalia.runAsync("hyprctl monitors all -j", function(result)
    if result.exitCode ~= 0 then
      refreshing = false
      loading = false
      error_message = "hyprctl no pudo consultar la configuración de monitores."
      render()
      return
    end

    local decoded, decode_error = noctalia.json.decode(result.stdout)
    if decoded == nil then
      refreshing = false
      loading = false
      error_message = "Respuesta JSON inválida: " .. tostring(decode_error or "desconocida")
      render()
      return
    end

    displays = {}
    for _, monitor in ipairs(decoded) do
      if monitor.disabled ~= true then
        table.insert(displays, {
          name = monitor.name,
          description = monitor.description,
          width = monitor.width,
          height = monitor.height,
          scale = monitor.scale,
          transform = monitor.transform or 0,
        })
      end
    end

    loading = false
    render()
    refresh_brightness()
  end)
end

function set_brightness(output, normalized_value)
  local percent = math.floor(math.max(0.1, math.min(1.0, normalized_value)) * 100 + 0.5)
  local targets = { output }
  if sync_brightness then
    targets = {}
    for _, candidate in ipairs(displays) do
      if candidate.ddc_bus ~= nil or candidate.name == output then
        table.insert(targets, candidate.name)
      end
    end
  end

  for _, target in ipairs(targets) do
    local display = nil
    for _, candidate in ipairs(displays) do
      if candidate.name == target then
        display = candidate
        break
      end
    end
    if display ~= nil then
      display.pending_brightness = percent
    end
  end
  render()

  for _, target in ipairs(targets) do
    local command = "noctalia msg brightness-set " .. shell_quote(target) .. " " .. tostring(percent)
    noctalia.runAsync(command, function(result)
      local display = nil
      for _, candidate in ipairs(displays) do
        if candidate.name == target then
          display = candidate
          break
        end
      end

      if result.exitCode ~= 0 then
        if display ~= nil then
          display.pending_brightness = nil
        end
        noctalia.notifyError("Brillo", "No se pudo cambiar el brillo de " .. target)
        render()
        return
      end

      if display ~= nil then
        display.pending_brightness = nil
        display.brightness = percent
        render()
      end
    end)
  end
end

function toggle_sync_brightness(value)
  sync_brightness = value == "true"
  render()
end

function rotate(output, rotation)
  local command = shell_quote(monitor_rotate) .. " " .. shell_quote(output) .. " " .. tostring(rotation)
  noctalia.runAsync(command, function(result)
    if result.exitCode ~= 0 then
      noctalia.notifyError("Orientación", "No se pudo rotar " .. output)
      return
    end

    noctalia.notify("Orientación", output .. " → " .. tostring(rotation * 90) .. "°")
    refresh()
  end)
end

function close_panel()
  panel.close()
end

function onOpen()
  refresh()
end

discover_ddc_displays(function() end)
