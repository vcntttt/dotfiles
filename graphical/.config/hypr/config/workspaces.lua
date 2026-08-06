-- Workspace rules wiki https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- Keep five persistent workspaces on each monitor. Odd workspaces belong to
-- the primary display and even workspaces belong to the secondary display.
hl.workspace_rule({ workspace = "name:gaming", monitor = PRIMARY_MONITOR, default = true })

for _, i in ipairs(WORKSPACES) do
    local monitor = PRIMARY_MONITOR
    if MONITOR2 then
        monitor = (i == 8 or i == 9) and PRIMARY_MONITOR
            or ((i % 2 == 1) and MONITOR1 or MONITOR2)
    end
    local default_name = HOST_WORKSPACE_NAMES and HOST_WORKSPACE_NAMES[i] or nil
    hl.workspace_rule({
        workspace = tostring(i),
        monitor = monitor,
        default = true,
        persistent = true,
        default_name = default_name,
        layout = HOST_SCROLLING_WORKSPACES and HOST_SCROLLING_WORKSPACES[i] and "scrolling" or nil,
    })
end
