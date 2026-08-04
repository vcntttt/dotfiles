local helper = noctalia.expandPath("~/.local/bin/noctalia-codex-usage")
local logo_url = "https://chatgpt.com/favicon.ico"
local data_dir = noctalia.pluginDataDir()
local logo_path = data_dir and (data_dir .. "/chatgpt-favicon.ico") or nil
local plan_path = data_dir and (data_dir .. "/daily-plan.json") or nil
local usage_history_path = data_dir and (data_dir .. "/usage-history.json") or nil
local logo_ready = logo_path ~= nil and noctalia.fileExists(logo_path)

local remaining = nil
local used = nil
local window_label = nil
local reset_label = nil
local reset_at = nil
local plan_type = nil
local reset_count = 0
local reset_credits = {}
local usage_summary = nil
local daily_buckets = nil
local usage_error = nil
local error_message = nil
local loading = false
local refresh_pending = false
local show_extended_activity = false
local daily_plan = nil
local daily_plan_state = nil
local usage_history = nil
local last_query_at = 0

local ACTIVE_START_HOUR = 10
local ACTIVE_HOURS_PER_DAY = 14
local QUERY_INTERVAL_SECONDS = 300
local UPDATE_INTERVAL_MS = 60000

local function shell_quote(value)
  return "'" .. string.gsub(value, "'", "'\\''") .. "'"
end

local months = {
  [1] = "ene", [2] = "feb", [3] = "mar", [4] = "abr",
  [5] = "may", [6] = "jun", [7] = "jul", [8] = "ago",
  [9] = "sep", [10] = "oct", [11] = "nov", [12] = "dic",
}

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

local function format_points(value)
  local number = tonumber(value)
  if number == nil then
    return "No Disponible"
  end

  local formatted = string.format("%.1f", math.max(0, number))
  return string.gsub(formatted, "%.", ",")
end

local function format_hours(value)
  local number = tonumber(value)
  if number == nil then
    return "No Disponible"
  end

  return format_points(number) .. " h"
end

local function local_parts(timestamp)
  local formatted = noctalia.formatTime("%Y-%m-%d %H:%M:%S %z", timestamp)
  local year, month, day, hour, minute, second, sign, offset_hour, offset_minute = string.match(
    formatted,
    "^(%d%d%d%d)-(%d%d)-(%d%d) (%d%d):(%d%d):(%d%d) ([+-])(%d%d)(%d%d)$"
  )
  if year == nil then
    local fallback = os.date("*t", timestamp)
    fallback.offsetMinutes = 0
    return fallback
  end

  local offset = (tonumber(offset_hour) * 60) + tonumber(offset_minute)
  if sign == "-" then
    offset = -offset
  end
  return {
    year = tonumber(year),
    month = tonumber(month),
    day = tonumber(day),
    hour = tonumber(hour),
    min = tonumber(minute),
    sec = tonumber(second),
    offsetMinutes = offset,
  }
end

local function date_key(timestamp)
  return noctalia.formatTime("%Y-%m-%d", timestamp)
end

local function timestamp_at(parts, hour)
  local utc_timestamp = os.time({
    year = parts.year,
    month = parts.month,
    day = parts.day,
    hour = hour,
    min = 0,
    sec = 0,
  })
  return utc_timestamp - ((parts.offsetMinutes or 0) * 60)
end

local function next_midnight(timestamp)
  local parts = local_parts(timestamp)
  parts.day = parts.day + 1
  return timestamp_at(parts, 0)
end

local function next_active_start(midnight)
  return timestamp_at(local_parts(midnight), ACTIVE_START_HOUR)
end

local function is_active_time(timestamp)
  return local_parts(timestamp).hour >= ACTIVE_START_HOUR
end

local function format_countdown(seconds)
  local remaining_seconds = math.max(0, tonumber(seconds) or 0)
  local days = math.floor(remaining_seconds / 86400)
  local hours = math.floor((remaining_seconds % 86400) / 3600)
  if days > 0 then
    return "En " .. tostring(days) .. " días y " .. tostring(hours) .. " horas"
  end
  return "En " .. tostring(hours) .. " horas"
end

local weekdays = {
  [0] = "Dom",
  [1] = "Lun",
  [2] = "Mar",
  [3] = "Mié",
  [4] = "Jue",
  [5] = "Vie",
  [6] = "Sáb",
}

local function read_daily_plan()
  if plan_path == nil then
    return nil
  end

  local ok, raw = pcall(function() return noctalia.readFile(plan_path) end)
  if not ok or type(raw) ~= "string" or raw == "" then
    return nil
  end

  local decoded = noctalia.json.decode(raw)
  if type(decoded) ~= "table" or tonumber(decoded.version) ~= 1 then
    return nil
  end
  return decoded
end

local function write_daily_plan(plan)
  if plan_path == nil or type(plan) ~= "table" then
    return
  end

  local ok, encoded = pcall(function() return noctalia.json.encode(plan) end)
  if ok and type(encoded) == "string" then
    noctalia.writeFile(plan_path, encoded)
  end
end

local function read_usage_history()
  if usage_history_path == nil then
    return nil
  end

  local ok, raw = pcall(function() return noctalia.readFile(usage_history_path) end)
  if not ok or type(raw) ~= "string" or raw == "" then
    return nil
  end

  local decoded = noctalia.json.decode(raw)
  if type(decoded) ~= "table" or tonumber(decoded.version) ~= 1 then
    return nil
  end
  if type(decoded.days) ~= "table" then
    decoded.days = {}
  end
  return decoded
end

local function write_usage_history(history)
  if usage_history_path == nil or type(history) ~= "table" then
    return
  end

  local ok, encoded = pcall(function() return noctalia.json.encode(history) end)
  if ok and type(encoded) == "string" then
    noctalia.writeFile(usage_history_path, encoded)
  end
end

local function new_usage_history(now, new_remaining, new_reset_at)
  local untracked_used = math.max(0, 100 - new_remaining)
  local days = {}

  -- The existing daily plan lets the first history sample retain today's
  -- observed consumption instead of classifying the whole lifetime as unknown.
  if daily_plan ~= nil
      and tonumber(daily_plan.resetAt) == tonumber(new_reset_at)
      and date_key(now) == date_key(daily_plan.baselineAt) then
    local baseline_remaining = tonumber(daily_plan.baselineRemainingPercent)
    local today_used = baseline_remaining and math.max(0, baseline_remaining - new_remaining) or 0
    untracked_used = math.max(0, 100 - (baseline_remaining or new_remaining))
    if today_used > 0 then
      days[date_key(now)] = today_used
    end
  end

  return {
    version = 1,
    resetAt = new_reset_at,
    lastRemaining = new_remaining,
    lastSampleAt = now,
    untrackedUsed = untracked_used,
    days = days,
  }
end

local function record_usage_sample(now, new_remaining, new_reset_at)
  if new_remaining == nil then
    return
  end

  local stored_reset_at = usage_history and tonumber(usage_history.resetAt) or nil
  local stored_last_remaining = usage_history and tonumber(usage_history.lastRemaining) or nil
  if usage_history == nil
      or stored_reset_at ~= tonumber(new_reset_at)
      or stored_last_remaining == nil
      or new_remaining > stored_last_remaining + 0.5 then
    usage_history = new_usage_history(now, new_remaining, new_reset_at)
    write_usage_history(usage_history)
    return
  end

  local delta = stored_last_remaining - new_remaining
  if delta > 0 then
    local last_sample_at = tonumber(usage_history.lastSampleAt)
    if last_sample_at ~= nil and date_key(last_sample_at) == date_key(now) then
      local key = date_key(now)
      usage_history.days[key] = (tonumber(usage_history.days[key]) or 0) + delta
    else
      usage_history.untrackedUsed = (tonumber(usage_history.untrackedUsed) or 0) + delta
    end
  end

  usage_history.lastRemaining = new_remaining
  usage_history.lastSampleAt = now
  write_usage_history(usage_history)
end

local function create_daily_plan(baseline_at, baseline_remaining, current_reset_at)
  if current_reset_at == nil or current_reset_at <= baseline_at or baseline_remaining == nil then
    return nil
  end

  local baseline_parts = local_parts(baseline_at)
  local day_start = timestamp_at(baseline_parts, ACTIVE_START_HOUR)
  local days = {}
  local total_active_hours = 0

  local iterations = 0
  while day_start < current_reset_at and iterations < 370 do
    iterations = iterations + 1
    local day_end = next_midnight(day_start)
    local active_start = math.max(day_start, baseline_at)
    local active_end = math.min(day_end, current_reset_at)
    if active_end > active_start then
      local active_hours = (active_end - active_start) / 3600
      table.insert(days, {
        date = date_key(day_start),
        startAt = active_start,
        endAt = active_end,
        activeHours = active_hours,
      })
      total_active_hours = total_active_hours + active_hours
    end
    day_start = next_active_start(day_end)
  end

  if total_active_hours <= 0 or #days == 0 then
    return nil
  end

  local accumulated = 0
  for _, day in ipairs(days) do
    day.budget = baseline_remaining * day.activeHours / total_active_hours
    accumulated = accumulated + day.budget
    day.remainingFloor = math.max(0, baseline_remaining - accumulated)
  end

  return {
    version = 1,
    planningDate = date_key(baseline_at),
    baselineAt = baseline_at,
    baselineRemainingPercent = baseline_remaining,
    resetAt = current_reset_at,
    days = days,
  }
end

local function plan_is_invalid(now)
  if type(daily_plan) ~= "table" or type(daily_plan.days) ~= "table" then
    return true
  end
  if #daily_plan.days == 0 or #daily_plan.days > 14 then
    return true
  end
  if tonumber(daily_plan.resetAt) ~= tonumber(reset_at) then
    return true
  end

  local baseline_remaining = tonumber(daily_plan.baselineRemainingPercent)
  if baseline_remaining == nil or remaining == nil then
    return true
  end
  if remaining > baseline_remaining + 0.5 then
    return true
  end

  local current_date = date_key(now)
  if current_date ~= daily_plan.planningDate and is_active_time(now) then
    return true
  end
  return false
end

local function active_hours_until(now, current_reset_at)
  if current_reset_at == nil or current_reset_at <= now then
    return 0
  end

  local total = 0
  local parts = local_parts(now)
  local start = timestamp_at(parts, ACTIVE_START_HOUR)
  local finish = next_midnight(start)
  if now >= finish then
    start = next_active_start(finish)
  end

  local iterations = 0
  while start < current_reset_at and iterations < 370 do
    iterations = iterations + 1
    finish = next_midnight(start)
    local segment_start = math.max(now, start)
    local segment_end = math.min(current_reset_at, finish)
    if segment_end > segment_start then
      total = total + (segment_end - segment_start) / 3600
    end
    start = next_active_start(finish)
  end
  return total
end

local function day_label(day, current_date)
  if day.date == current_date then
    return "Hoy"
  end
  return weekdays[tonumber(noctalia.formatTime("%w", day.startAt))] or day.date
end

local function find_today_day(now)
  if daily_plan == nil or type(daily_plan.days) ~= "table" then
    return nil, nil
  end

  local current_date = date_key(now)
  for index, day in ipairs(daily_plan.days) do
    if day.date == current_date then
      return index, day
    end
  end
  return nil, nil
end

local function build_usage_segments(now)
  local segments = {}
  if usage_history == nil then
    return segments
  end

  local untracked_used = math.max(0, tonumber(usage_history.untrackedUsed) or 0)
  if untracked_used > 0.01 then
    table.insert(segments, {
      key = "untracked",
      amount = untracked_used,
      kind = "untracked",
    })
  end

  local today_key = date_key(now)
  local day_keys = {}
  for key, value in pairs(usage_history.days or {}) do
    if key ~= today_key and tonumber(value) ~= nil and tonumber(value) > 0.01 then
      table.insert(day_keys, key)
    end
  end

  table.sort(day_keys)
  for _, key in ipairs(day_keys) do
    table.insert(segments, {
      key = key,
      amount = math.max(0, tonumber(usage_history.days[key]) or 0),
      kind = "past",
    })
  end

  local today_used = math.max(0, tonumber(usage_history.days[today_key]) or 0)
  if today_used > 0.01 then
    table.insert(segments, {
      key = today_key,
      amount = today_used,
      kind = "today",
      highlighted = true,
    })
  end

  if #segments == 0 then
    local fallback_used = math.max(0, 100 - (tonumber(remaining) or 100))
    if fallback_used > 0.01 then
      table.insert(segments, {
        key = "untracked",
        amount = fallback_used,
        kind = "untracked",
      })
    end
  end
  return segments
end

local function build_limit_markers(now)
  local markers = {}
  if daily_plan == nil or type(daily_plan.days) ~= "table" then
    return markers
  end

  for _, day in ipairs(daily_plan.days) do
    local remaining_floor = tonumber(day.remainingFloor)
    if remaining_floor ~= nil then
      table.insert(markers, {
        key = day.date,
        usedTarget = math.max(0, math.min(100, 100 - remaining_floor)),
        today = day.date == date_key(now),
      })
    end
  end
  return markers
end

local function make_plan_state(now)
  if remaining == nil then
    return nil
  end
  if daily_plan == nil or type(daily_plan.days) ~= "table" then
    if not is_active_time(now) and reset_at ~= nil then
      return {
        active = false,
        status = "inactive",
        segments = build_usage_segments(now),
        markers = build_limit_markers(now),
        legend = "",
        activeHoursToday = 0,
        activeHoursUntilReset = active_hours_until(now, reset_at),
      }
    end
    return nil
  end

  local current_index, current_day = find_today_day(now)
  local active = is_active_time(now) and current_day ~= nil
  local current_remaining = math.max(0, math.min(100, remaining))
  local used_since_baseline = math.max(
    0,
    (tonumber(daily_plan.baselineRemainingPercent) or current_remaining) - current_remaining
  )
  local today_budget = current_day and tonumber(current_day.budget) or 0
  local today_budget_left = today_budget - used_since_baseline
  local active_hours_today = active and math.max(0, (current_day.endAt - now) / 3600) or 0
  local hours_until_reset = active_hours_until(now, reset_at)
  local current_floor = current_day and tonumber(current_day.remainingFloor) or current_remaining
  local status = "inactive"
  if active then
    if today_budget_left < -0.1 then
      status = "exceeded"
    elseif today_budget_left <= 0.1 then
      status = "exhausted"
    else
      status = "available"
    end
  end

  local segments = build_usage_segments(now)
  local markers = build_limit_markers(now)
  local legend = {}
  for index = current_index or 1, #daily_plan.days do
    local day = daily_plan.days[index]
    table.insert(legend, day_label(day, date_key(now)) .. " " .. format_percent(day.remainingFloor))
  end
  return {
    active = active,
    status = status,
    currentDay = current_day,
    currentIndex = current_index,
    todayBudget = today_budget,
    usedToday = used_since_baseline,
    todayBudgetLeft = today_budget_left,
    activeHoursToday = active_hours_today,
    activeHoursUntilReset = hours_until_reset,
    remainingFloor = current_floor,
    segments = segments,
    markers = markers,
    legend = "Metas: " .. table.concat(legend, " · "),
  }
end

local function ensure_daily_plan(now)
  if remaining == nil or reset_at == nil then
    daily_plan_state = nil
    return
  end

  if plan_is_invalid(now) then
    daily_plan = nil
  end

  if daily_plan == nil and is_active_time(now) then
    daily_plan = create_daily_plan(now, remaining, reset_at)
    write_daily_plan(daily_plan)
  end
  daily_plan_state = make_plan_state(now)
end

local function apply_data(data)
  local new_remaining = tonumber(data.remainingPercent)
  if new_remaining == nil then
    usage_error = data.error or "Codex devolvió datos de uso incompletos"
    return false
  end

  local new_reset_at = tonumber(data.resetsAt)
  local now = os.time()
  record_usage_sample(now, new_remaining, new_reset_at)

  remaining = new_remaining
  used = tonumber(data.usedPercent)
  window_label = data.windowLabel
  reset_label = data.resetLabel
  reset_at = new_reset_at
  plan_type = capitalize(data.planType)
  reset_count = tonumber(data.availableResetCount) or 0
  reset_credits = type(data.resetCredits) == "table" and data.resetCredits or {}
  usage_summary = type(data.usageSummary) == "table" and data.usageSummary or nil
  daily_buckets = type(data.dailyUsageBuckets) == "table" and data.dailyUsageBuckets or nil
  usage_error = data.usageError
  ensure_daily_plan(os.time())
  return true
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

local function render_weekly_markers(state, used_value)
  local markers = {}
  local last_target = nil

  for _, marker in ipairs(state.markers or {}) do
    local target = math.max(0.8, math.min(99.2, tonumber(marker.usedTarget) or 0.8))
    local overlaps_current_usage = marker.today == true
      and math.abs(target - used_value) < 0.25
    if not overlaps_current_usage and (last_target == nil or target - last_target >= 0.75) then
      table.insert(markers, {
        key = marker.key,
        usedTarget = target,
        today = marker.today == true,
      })
      last_target = target
    end
  end

  if #markers == 0 then
    return nil
  end

  local children = {}
  local cursor = 0
  for index, marker in ipairs(markers) do
    local target = marker.usedTarget
    if target > cursor then
      table.insert(children, ui.spacer({
        key = "marker-space-before-" .. tostring(index),
        flexGrow = target - cursor,
      }))
    end
    table.insert(children, ui.box({
      key = "marker-" .. tostring(marker.key),
      width = 2,
      height = marker.today and 8 or 6,
      fill = marker.today and "primary" or "primary/0.45",
      radius = 0,
    }))
    cursor = target
  end

  if cursor < 100 then
    table.insert(children, ui.spacer({
      key = "marker-space-after",
      flexGrow = 100 - cursor,
    }))
  end

  return ui.row({ height = 8, gap = 0 }, children)
end

local function render_weekly_bar(state)
  local used_value = math.max(0, math.min(100, tonumber(used) or (100 - (tonumber(remaining) or 100))))
  local remaining_value = 100 - used_value
  local used_children = {}

  for index, segment in ipairs(state.segments or {}) do
    local amount = math.max(0, tonumber(segment.amount) or 0)
    if amount > 0.01 then
      local fill = "primary/0.30"
      if segment.kind == "past" then
        fill = "primary/0.45"
      elseif segment.kind == "today" then
        fill = "#00000000"
      end

      table.insert(used_children, ui.box({
        key = "usage-segment-" .. tostring(segment.key or index),
        flexGrow = amount,
        height = 14,
        fill = fill,
        radius = 0,
      }))
    end
  end

  local bar_children = {}
  if used_value > 0 then
    table.insert(bar_children, ui.row({
      key = "used-area",
      flexGrow = used_value,
      height = 14,
      gap = 0,
      fill = "primary",
      radius = 8,
    }, used_children))
  end

  if remaining_value > 0 then
    table.insert(bar_children, ui.spacer({
      key = "remaining-area",
      flexGrow = remaining_value,
    }))
  end

  local children = {}
  local markers = render_weekly_markers(state, used_value)
  if markers ~= nil then
    table.insert(children, markers)
  end
  table.insert(children, ui.row({
    height = 14,
    gap = 0,
    fill = "surface_variant",
    radius = 8,
  }, bar_children))

  if state.legend ~= nil and state.legend ~= "" then
    table.insert(children, ui.label({ text = state.legend, color = "on_surface_variant", maxLines = 2 }))
  end
  return ui.column({ gap = 3 }, children)
end

local function render_daily_budget()
  if daily_plan_state == nil then
    return nil
  end

  local state = daily_plan_state
  local children = {
    ui.row({ align = "center", gap = 8 }, {
      ui.glyph({ name = "calendar", size = 18, color = "secondary" }),
      ui.label({ text = "Presupuesto de Hoy", fontWeight = "bold", color = "secondary" }),
    }),
  }

  if not state.active then
    table.insert(children, ui.label({ text = "Horario Inactivo", fontWeight = "bold", color = "on_surface" }))
    table.insert(children, ui.label({ text = "Próximo bloque de uso: 10:00–00:00", color = "on_surface_variant" }))
    table.insert(children, ui.label({
      text = "El presupuesto diario se calculará a las 10:00",
      color = "on_surface_variant",
    }))
  else
    if state.status == "exceeded" then
      table.insert(children, ui.label({
        text = "Presupuesto diario excedido por " .. format_points(-state.todayBudgetLeft) .. " puntos",
        fontWeight = "bold",
        color = "error",
      }))
      table.insert(children, ui.label({
        text = "El presupuesto de mañana se reajustará a las 10:00",
        color = "on_surface_variant",
      }))
    elseif state.status == "exhausted" then
      table.insert(children, ui.label({
        text = "Presupuesto diario agotado",
        fontWeight = "bold",
        color = "primary",
      }))
    else
      table.insert(children, ui.label({
        text = format_points(state.todayBudgetLeft) .. " puntos disponibles hasta las 00:00",
        fontWeight = "bold",
        color = "on_surface",
      }))
    end

    table.insert(children, ui.label({
      text = "Has usado " .. format_points(state.usedToday) .. " de " .. format_points(state.todayBudget) .. " puntos",
      color = "on_surface_variant",
    }))

    if state.status ~= "exceeded" then
      local hours_left = math.max(0.01, state.activeHoursToday)
      table.insert(children, ui.label({
        text = "Ritmo sostenible: " .. format_points(math.max(0, state.todayBudgetLeft) / hours_left)
          .. " puntos/h activa",
        color = "on_surface_variant",
      }))
    end

    table.insert(children, ui.label({
      text = "Meta al cierre: " .. format_percent(state.remainingFloor) .. " restante",
      color = "on_surface_variant",
    }))
    table.insert(children, ui.label({
      text = format_hours(state.activeHoursToday) .. " activas hoy · "
        .. format_hours(state.activeHoursUntilReset) .. " hasta el reset semanal",
      color = "on_surface_variant",
    }))
  end

  if error_message ~= nil then
    table.insert(children, ui.label({ text = "Datos de uso desactualizados", color = "error" }))
  end
  table.insert(children, render_weekly_bar(state))

  return ui.column({
    fill = "secondary/0.12",
    border = "secondary/0.35",
    borderWidth = 1,
    radius = 12,
    padding = 12,
    gap = 4,
  }, children)
end

local function render()
  local now = os.time()
  ensure_daily_plan(now)
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
        ui.label({ text = "Reset Semanal", color = "on_surface_variant" }),
        ui.label({
          text = (reset_label or "Sin Fecha Disponible")
            .. (reset_at and (" · " .. format_countdown(math.max(0, reset_at - now))) or ""),
          color = "on_surface",
        }),
      }),
    }))

    local manual_reset_card = nil
    if reset_count > 0 then
      local credit = reset_credits[1]
      local expires = credit and credit.expiresLabel or "Vencimiento No Disponible"
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
          ui.label({
            text = tostring(reset_count) .. " reset manual disponible",
            fontWeight = "bold",
            color = "primary",
          }),
        }),
        ui.label({ text = "Reset manual completo · Vence: " .. expires, color = "on_surface_variant" }),
      })
    end

    local daily_budget_card = render_daily_budget()
    if daily_budget_card ~= nil then
      table.insert(content, daily_budget_card)
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

  if apply_data(data) then
    error_message = nil
  else
    error_message = usage_error or "Respuesta de Uso Inválida"
  end
  render()
end

local function refresh()
  if refresh_pending then
    return
  end

  refresh_pending = true
  last_query_at = os.time()
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
  noctalia.setUpdateInterval(UPDATE_INTERVAL_MS)
  local now = os.time()
  ensure_daily_plan(now)
  if last_query_at == 0 or now - last_query_at >= QUERY_INTERVAL_SECONDS then
    refresh()
  else
    render()
  end
end

daily_plan = read_daily_plan()
usage_history = read_usage_history()
download_logo()
