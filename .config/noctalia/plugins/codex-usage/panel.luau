local helper = noctalia.expandPath("~/.local/bin/noctalia-codex-usage")
local dashboard_url = "https://chatgpt.com/codex/cloud/settings/analytics#usage"
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
local reset_credits = {}
local usage_summary = nil
local daily_buckets = nil
local daily_budget = nil
local usage_error = nil
local error_message = nil
local loading = false
local refresh_pending = false
local show_extended_activity = false

local months = {
  [1] = "ene", [2] = "feb", [3] = "mar", [4] = "abr",
  [5] = "may", [6] = "jun", [7] = "jul", [8] = "ago",
  [9] = "sep", [10] = "oct", [11] = "nov", [12] = "dic",
}

local function shell_quote(value)
  return "'" .. string.gsub(value, "'", "'\\''") .. "'"
end

local function capitalize(value)
  if value == nil or value == "" then
    return value
  end

  return string.upper(string.sub(value, 1, 1)) .. string.sub(value, 2)
end

local function format_tokens(value)
  local tokens = tonumber(value)
  if tokens == nil then
    return "No Disponible"
  elseif tokens >= 1000000000 then
    return string.format("%.1f B", tokens / 1000000000)
  elseif tokens >= 1000000 then
    return string.format("%.1f M", tokens / 1000000)
  elseif tokens >= 1000 then
    return string.format("%.1f K", tokens / 1000)
  end

  return tostring(math.floor(tokens + 0.5))
end

local function format_duration(seconds)
  local duration = tonumber(seconds)
  if duration == nil then
    return "No Disponible"
  end

  duration = math.max(0, math.floor(duration))
  local hours = math.floor(duration / 3600)
  local minutes = math.floor((duration % 3600) / 60)
  if hours > 0 then
    return tostring(hours) .. " h " .. tostring(minutes) .. " min"
  end
  return tostring(minutes) .. " min"
end

local function format_percent(value)
  local number = tonumber(value)
  if number == nil then
    return "No Disponible"
  end

  local formatted = string.format("%.1f", number)
  return string.gsub(formatted, "%.", ",") .. "%"
end

local function format_date(value)
  local year, month, day = string.match(value or "", "^(%d%d%d%d)-(%d%d)-(%d%d)$")
  if year == nil then
    return value or "Fecha Desconocida"
  end

  return tostring(tonumber(day)) .. " " .. (months[tonumber(month)] or month)
end

local function apply_data(data)
  remaining = tonumber(data.remainingPercent)
  used = tonumber(data.usedPercent)
  window_label = data.windowLabel
  reset_label = data.resetLabel
  plan_type = capitalize(data.planType)
  reset_count = tonumber(data.availableResetCount) or 0
  reset_credits = type(data.resetCredits) == "table" and data.resetCredits or {}
  usage_summary = type(data.usageSummary) == "table" and data.usageSummary or nil
  daily_buckets = type(data.dailyUsageBuckets) == "table" and data.dailyUsageBuckets or nil
  daily_budget = type(data.dailyBudget) == "table" and data.dailyBudget or nil
  usage_error = data.usageError
end

local function logo()
  if logo_ready then
    return ui.image({ path = logo_path, width = 28, height = 28, radius = 7, fit = "contain" })
  end

  return ui.glyph({ name = "code", size = 24, color = "primary" })
end

local function stat(label, value)
  return ui.column({
    flexGrow = 1,
    fill = "surface_variant/0.55",
    radius = 10,
    padding = 10,
    gap = 3,
  }, {
    ui.label({ text = label, color = "on_surface_variant", maxLines = 1 }),
    ui.label({ text = value, fontWeight = "bold", color = "on_surface" }),
  })
end

local function recent_activity()
  if type(daily_buckets) ~= "table" or #daily_buckets == 0 then
    return {}
  end

  local buckets = {}
  for _, bucket in ipairs(daily_buckets) do
    if type(bucket) == "table" and type(bucket.startDate) == "string" and tonumber(bucket.tokens) ~= nil then
      table.insert(buckets, bucket)
    end
  end

  table.sort(buckets, function(left, right)
    return left.startDate < right.startDate
  end)

  local recent = {}
  local first = math.max(1, #buckets - 6)
  for index = first, #buckets do
    table.insert(recent, buckets[index])
  end
  return recent
end

local function render()
  local subtitle = plan_type and ("Plan " .. plan_type) or "Cuenta de Codex"
  local header = ui.row({ align = "center", gap = 12 }, {
    logo(),
    ui.column({ gap = 2, flexGrow = 1 }, {
      ui.label({ text = "Codex", fontSize = 19, fontWeight = "bold", color = "on_surface" }),
      ui.label({ text = subtitle, color = "on_surface_variant" }),
    }),
    ui.button({ glyph = "close", tooltip = "Cerrar", variant = "ghost", onClick = function() panel.close() end }),
  })

  local content = {}
  if loading and remaining == nil then
    table.insert(content, ui.label({ text = "Consultando Uso…", color = "on_surface_variant" }))
  elseif remaining ~= nil and used ~= nil then
    table.insert(content, ui.column({ gap = 10 }, {
      ui.row({ align = "center", justify = "space_between" }, {
        ui.label({ text = window_label or "Uso de Codex", color = "on_surface_variant" }),
        ui.label({ text = tostring(remaining) .. "% Restante", fontWeight = "bold", color = "primary" }),
      }),
      ui.progress({
        progress = remaining / 100,
        fill = "primary",
        track = "surface_variant",
        radius = 8,
        height = 14,
      }),
      ui.label({ text = tostring(used) .. "% Usado", color = "on_surface_variant" }),
    }))

    table.insert(content, ui.separator({ thickness = 1, color = "outline", spacing = 2 }))
    table.insert(content, ui.row({ align = "center", gap = 10 }, {
      ui.glyph({ name = "calendar", size = 18, color = "secondary" }),
      ui.column({ gap = 2, flexGrow = 1 }, {
        ui.label({ text = "Restablecimiento", color = "on_surface_variant" }),
        ui.label({ text = reset_label or "Sin Fecha Disponible", color = "on_surface" }),
      }),
    }))

    local manual_reset_card = nil
    if reset_count > 0 then
      local credit = reset_credits[1]
      local expires = credit and credit.expiresLabel or "Vencimiento No Disponible"
      local title = credit and credit.title or "Reset Completo"
      if title == "Full reset" then
        title = "Reset Completo"
      end
      manual_reset_card = ui.column({
        fill = "primary/0.12",
        border = "primary/0.35",
        borderWidth = 1,
        radius = 12,
        padding = 12,
        gap = 4,
      }, {
        ui.row({ align = "center", gap = 8 }, {
          ui.glyph({ name = "refresh", size = 18, color = "primary" }),
          ui.label({ text = tostring(reset_count) .. " Reset Disponible", fontWeight = "bold", color = "primary" }),
        }),
        ui.label({ text = title .. " · Vence: " .. expires, color = "on_surface_variant" }),
      })
    end

    if daily_budget ~= nil and daily_budget.recommendedDailyPercent ~= nil then
      table.insert(content, ui.column({
        fill = "secondary/0.12",
        border = "secondary/0.35",
        borderWidth = 1,
        radius = 12,
        padding = 12,
        gap = 4,
      }, {
        ui.row({ align = "center", gap = 8 }, {
          ui.glyph({ name = "calendar", size = 18, color = "secondary" }),
          ui.label({ text = "Ritmo Recomendado", fontWeight = "bold", color = "secondary" }),
        }),
        ui.label({
          text = format_percent(daily_budget.recommendedDailyPercent) .. " por Día Activo",
          fontWeight = "bold",
          color = "on_surface",
        }),
        ui.label({
          text = "Hoy: " .. format_percent(daily_budget.recommendedTodayPercent)
            .. " · Quedan " .. tostring(daily_budget.activeHoursToday or 0) .. " h Activas",
          color = "on_surface_variant",
        }),
        ui.label({
          text = "Hasta el Restablecimiento · Activo: " .. tostring(daily_budget.activeHoursUntilReset or 0) .. " h",
          color = "on_surface_variant",
        }),
      }))
    end

    if manual_reset_card ~= nil then
      table.insert(content, manual_reset_card)
    end

    if show_extended_activity and usage_summary ~= nil then
      table.insert(content, ui.separator({ thickness = 1, color = "outline", spacing = 2 }))
      table.insert(content, ui.label({ text = "Actividad Diaria", fontWeight = "bold", color = "on_surface" }))
      table.insert(content, ui.row({ gap = 10 }, {
        stat("Lifetime", format_tokens(usage_summary.lifetimeTokens)),
        stat("Pico Diario", format_tokens(usage_summary.peakDailyTokens)),
      }))
      table.insert(content, ui.row({ gap = 10 }, {
        stat("Racha Actual", tostring(usage_summary.currentStreakDays or "No Disponible") .. " días"),
        stat("Racha Máxima", tostring(usage_summary.longestStreakDays or "No Disponible") .. " días"),
      }))
      table.insert(content, ui.label({
        text = "Tarea Más Larga: " .. format_duration(usage_summary.longestRunningTurnSec),
        color = "on_surface_variant",
      }))

      local recent = recent_activity()
      if #recent > 0 then
        local maximum = 0
        for _, bucket in ipairs(recent) do
          maximum = math.max(maximum, tonumber(bucket.tokens) or 0)
        end
        maximum = math.max(maximum, 1)

        table.insert(content, ui.label({ text = "Últimos Días Con Actividad", color = "on_surface_variant" }))
        for index = #recent, 1, -1 do
          local bucket = recent[index]
          table.insert(content, ui.row({ align = "center", gap = 8 }, {
            ui.label({ text = format_date(bucket.startDate), width = 48, color = "on_surface_variant" }),
            ui.progress({
              progress = math.min(1, (tonumber(bucket.tokens) or 0) / maximum),
              fill = "secondary",
              track = "surface_variant",
              radius = 4,
              height = 8,
              flexGrow = 1,
            }),
            ui.label({ text = format_tokens(bucket.tokens), width = 54, color = "on_surface_variant" }),
          }))
        end
      end
    elseif show_extended_activity and usage_error ~= nil then
      table.insert(content, ui.label({ text = "Actividad Diaria: " .. usage_error, color = "on_surface_variant" }))
    end
  else
    table.insert(content, ui.label({ text = error_message or "No Hay Datos de Uso Disponibles.", color = "error" }))
  end

  if error_message ~= nil and remaining ~= nil then
    table.insert(content, ui.label({ text = "Última Actualización Fallida: " .. error_message, color = "error", maxLines = 2 }))
  end

  local panel_children = { header }
  for _, item in ipairs(content) do
    table.insert(panel_children, item)
  end

  panel.render(ui.column({ flexGrow = 1, gap = 14, padding = 20, align = "stretch" }, panel_children))
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
  loading = false
  if result.exitCode ~= 0 then
    error_message = "El Helper Terminó Con Error"
    render()
    return
  end

  local data = noctalia.json.decode(result.stdout)
  if data == nil or data.ok ~= true then
    error_message = data and data.error or "Respuesta Inválida"
    render()
    return
  end

  apply_data(data)
  error_message = nil
  render()
end

local function refresh()
  if refresh_pending then
    return
  end

  refresh_pending = true
  noctalia.runAsync(shell_quote(helper), function(result)
    refresh_pending = false
    update_from_result(result)
  end)
end

function onOpen()
  loading = remaining == nil
  error_message = nil
  render()
  refresh()
end

function update()
  noctalia.setUpdateInterval(300000)
end

download_logo()
