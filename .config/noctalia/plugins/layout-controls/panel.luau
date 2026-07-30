local layout_script = "/home/vrivera/dotfiles/.local/bin/hypr-layout"
local workspace_id = "?"
local current_layout = "desconocido"
local loading = true
local error_message = nil
local target_monitor = ""
local focused_index = 1

local layouts = {
  { id = "master", name = "Master", description = "Una ventana principal y las demás apiladas." },
  { id = "dwindle", name = "Dwindle", description = "Distribución en árbol con splits dinámicos." },
  { id = "scrolling", name = "Scrolling", description = "Ventanas organizadas en una columna desplazable." },
}

local function shell_quote(value)
  return "'" .. string.gsub(value, "'", "'\\''") .. "'"
end

local function layout_query_command()
  if target_monitor == "" then
    return layout_script
  end

  return layout_script .. " --monitor " .. shell_quote(target_monitor)
end

local function layout_apply_command(layout)
  if target_monitor == "" then
    return layout_script .. " " .. layout
  end

  return layout_script .. " --monitor " .. shell_quote(target_monitor) .. " " .. layout
end

local function render()
  local children = {
    ui.row({ align = "center", gap = 8 }, {
      ui.glyph({ name = "layout-grid", size = 22, color = "primary" }),
      ui.column({ gap = 2, flexGrow = 1 }, {
        ui.label({ text = "Layout del workspace", fontSize = 18, fontWeight = "bold", color = "on_surface" }),
        ui.label({
          text = (target_monitor ~= "" and (target_monitor .. " · ") or "") .. "Workspace " .. workspace_id,
          color = "on_surface_variant",
        }),
      }),
      ui.button({ glyph = "close", tooltip = "Cerrar", variant = "ghost", onClick = function() panel.close() end }),
    }),
  }

  if loading then
    table.insert(children, ui.label({ text = "Consultando layout…", color = "on_surface_variant" }))
  else
    if error_message ~= nil then
      table.insert(children, ui.label({ text = error_message, color = "error" }))
    end

    for layout_index, layout in ipairs(layouts) do
      local selected = current_layout == layout.id
      local focused = focused_index == layout_index
      local prefix = selected and "✓  " or (focused and "›  " or "")
      table.insert(children, ui.button({
        key = "layout:" .. layout.id,
        text = prefix .. layout.name,
        tooltip = layout.description,
        variant = selected and "primary" or (focused and "secondary" or "outline"),
        selected = selected,
        controlSize = "lg",
        contentAlign = "start",
        onClick = function()
          apply_layout(layout.id)
        end,
      }))
    end

    if error_message ~= nil then
      table.insert(children, ui.button({
        text = "Reintentar",
        variant = "outline",
        onClick = "refresh",
      }))
    end
  end

  panel.render(ui.column({ gap = 12, padding = 4 }, children))
end

local function update_workspace_id()
  local command = target_monitor == "" and "hyprctl -j activeworkspace" or "hyprctl -j monitors"
  noctalia.runAsync(command, function(result)
    if result.exitCode == 0 then
      local decoded = noctalia.json.decode(result.stdout)
      if decoded ~= nil then
        if target_monitor == "" then
          workspace_id = tostring(decoded.id or workspace_id)
        else
          for _, monitor in ipairs(decoded) do
            if monitor.name == target_monitor then
              workspace_id = tostring((monitor.activeWorkspace or {}).id or workspace_id)
              break
            end
          end
        end
      end
    end

    loading = false
    render()
  end)
end

local function move_focus(delta)
  focused_index = focused_index + delta
  if focused_index < 1 then
    focused_index = #layouts
  elseif focused_index > #layouts then
    focused_index = 1
  end
  render()
end

function onKey(chord, pressed)
  if not pressed or loading then
    return
  end

  if chord == "Up" or chord == "up" or chord == "Left" or chord == "left" then
    move_focus(-1)
  elseif chord == "Down" or chord == "down" or chord == "Right" or chord == "right" then
    move_focus(1)
  elseif chord == "Return" then
    apply_layout(layouts[focused_index].id)
  end
end

function refresh()
  loading = true
  error_message = nil
  render()

  noctalia.runAsync(layout_query_command(), function(result)
    if result.exitCode ~= 0 then
      loading = false
      error_message = "No se pudo consultar el workspace de " .. (target_monitor ~= "" and target_monitor or "este monitor") .. "."
      render()
      return
    end

    local value = string.match(result.stdout, "([^\n]+)")
    if value == nil or value == "" then
      loading = false
      error_message = "Hyprland no devolvió un layout válido."
      render()
      return
    end

    current_layout = value
    for index, layout in ipairs(layouts) do
      if layout.id == current_layout then
        focused_index = index
        break
      end
    end
    update_workspace_id()
  end)
end

function apply_layout(layout)
  loading = true
  error_message = nil
  render()

  noctalia.runAsync(layout_apply_command(layout), function(result)
    if result.exitCode ~= 0 then
      loading = false
      error_message = "No se pudo aplicar el layout: " .. string.gsub(result.stderr or "error desconocido", "\n", " ")
      render()
      return
    end

    current_layout = layout
    loading = false
    render()
  end)
end

function onOpen(context)
  target_monitor = context or ""
  refresh()
end

refresh()
