local helper = noctalia.expandPath("~/.local/bin/noctalia-codex-usage")
local logo_url = "https://chatgpt.com/favicon.ico"
local data_dir = noctalia.pluginDataDir()
local logo_path = data_dir and (data_dir .. "/chatgpt-favicon.ico") or nil
local logo_ready = logo_path ~= nil and noctalia.fileExists(logo_path)

local remaining = nil
local used = nil
local window_label = nil
local reset_label = nil
local plan_type = nil
local reset_count = 0
local reset_expires_label = nil
local recommended_daily_percent = nil
local last_error = nil
local refresh_pending = false

local function shell_quote(value)
  return "'" .. string.gsub(value, "'", "'\\''") .. "'"
end

local function capitalize(value)
  if value == nil or value == "" then
    return value
  end

  return string.upper(string.sub(value, 1, 1)) .. string.sub(value, 2)
end

local function render_logo()
  if logo_ready then
    barWidget.setGlyph("")
    barWidget.setImage(logo_path)
  else
    barWidget.setImage("")
    barWidget.setGlyph("code")
  end
end

local function render()
  render_logo()

  if remaining == nil then
    barWidget.setText("?")
    barWidget.setTooltip(last_error or "Codex · Consultando Uso")
    return
  end

  barWidget.setText(tostring(remaining) .. "%")

  local tooltip = "Codex · " .. tostring(remaining) .. "% Restante"
  if used ~= nil then
    tooltip = tooltip .. " (" .. tostring(used) .. "% Usado)"
  end
  if plan_type ~= nil then
    tooltip = tooltip .. "\nPlan: " .. capitalize(plan_type)
  end
  if window_label ~= nil then
    tooltip = tooltip .. "\n" .. window_label
  end
  if reset_label ~= nil then
    tooltip = tooltip .. " · Restablece: " .. reset_label
  end
  if reset_count > 0 then
    tooltip = tooltip .. "\n" .. tostring(reset_count) .. " Reset Disponible"
    if reset_expires_label ~= nil then
      tooltip = tooltip .. " · Vence: " .. reset_expires_label
    end
  end
  if recommended_daily_percent ~= nil then
    tooltip = tooltip .. "\nRitmo Recomendado: " .. tostring(recommended_daily_percent) .. "% por Día Activo"
  end
  if last_error ~= nil then
    tooltip = tooltip .. "\nÚltima Actualización Fallida: " .. last_error
  end

  barWidget.setTooltip(tooltip)
end

local function download_logo()
  if logo_path == nil or logo_ready then
    return
  end

  noctalia.http({
    url = logo_url,
    headers = {
      "User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/138 Safari/537.36",
      "Accept: image/avif,image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8",
    },
  }, function(response)
    if response.ok and response.status == 200 and response.body ~= nil then
      logo_ready = noctalia.writeFile(logo_path, response.body) == true
      if logo_ready then
        render()
      end
    end
  end)
end

local function update_from_result(result)
  if result.exitCode ~= 0 then
    last_error = "El Helper Terminó Con Error"
    render()
    return
  end

  local data = noctalia.json.decode(result.stdout)
  if data == nil or data.ok ~= true then
    last_error = data and data.error or "Respuesta Inválida"
    render()
    return
  end

  remaining = tonumber(data.remainingPercent)
  used = tonumber(data.usedPercent)
  window_label = data.windowLabel
  reset_label = data.resetLabel
  plan_type = capitalize(data.planType)
  reset_count = tonumber(data.availableResetCount) or 0
  local credits = type(data.resetCredits) == "table" and data.resetCredits or {}
  reset_expires_label = credits[1] and credits[1].expiresLabel or nil
  local budget = type(data.dailyBudget) == "table" and data.dailyBudget or {}
  recommended_daily_percent = budget.recommendedDailyPercent
  last_error = nil
  render()
end

function onClick()
  noctalia.togglePanel("vrivera/codex-usage:details")
end

function update()
  noctalia.setUpdateInterval(300000)
  if refresh_pending then
    return
  end

  refresh_pending = true
  noctalia.runAsync(shell_quote(helper), function(result)
    refresh_pending = false
    update_from_result(result)
  end)
end

render()
update()

download_logo()
