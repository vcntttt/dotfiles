local current_layout = "desconocido"
local workspace_id = "?"
local output_name = tostring(barWidget.outputName() or "")

local layout_names = {
  master = "Master",
  dwindle = "Dwindle",
  scrolling = "Scrolling",
}

local function render()
  local label = layout_names[current_layout] or current_layout
  barWidget.setGlyph("layout-grid")
  barWidget.setText(label)
  barWidget.setTooltip(output_name .. " · Workspace " .. workspace_id .. " · Layout " .. label)
end

function onClick()
  local context = output_name == "" and "" or (" '" .. string.gsub(output_name, "'", "'\\''") .. "'")
  noctalia.runAsync(
    "noctalia msg panel-toggle vrivera/layout-controls:selector" .. context,
    function() end
  )
end

function update()
  noctalia.setUpdateInterval(1000)
  noctalia.runAsync("hyprctl -j monitors", function(monitor_result)
    if monitor_result.exitCode ~= 0 then
      return
    end

    local monitors = noctalia.json.decode(monitor_result.stdout)
    if monitors == nil then
      return
    end

    local active_workspace_id = nil
    for _, monitor in ipairs(monitors) do
      if output_name == "" then
        if monitor.focused == true then
          active_workspace_id = (monitor.activeWorkspace or {}).id
          break
        end
      elseif monitor.name == output_name then
        active_workspace_id = (monitor.activeWorkspace or {}).id
        break
      end
    end

    if active_workspace_id == nil then
      return
    end

    workspace_id = tostring(active_workspace_id)
    noctalia.runAsync("hyprctl -j workspaces", function(workspace_result)
      if workspace_result.exitCode ~= 0 then
        return
      end

      local workspaces = noctalia.json.decode(workspace_result.stdout)
      if workspaces == nil then
        return
      end

      for _, workspace in ipairs(workspaces) do
        if workspace.id == active_workspace_id then
          current_layout = workspace.tiledLayout or "desconocido"
          break
        end
      end

      render()
    end)
  end)
end

render()
update()
