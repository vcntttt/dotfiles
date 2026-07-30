-- Workspace rules wiki https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- Keep five persistent workspaces on each monitor. Odd workspaces belong to
-- the primary display and even workspaces belong to the secondary display.
hl.workspace_rule({ workspace = "name:gaming", monitor = PRIMARY_MONITOR, default = true })

for i = 1, TOTAL_WORKSPACES do
    local monitor = (i == 8 or i == 9) and PRIMARY_MONITOR
        or ((i % 2 == 1) and MONITOR1 or MONITOR2)
    local default_name = (i == 1 or i == 2) and "󰖟"
        or i == 3 and ""
        or i == 4 and ""
        or i == 8 and ""
        or i == 9 and "󰓇"
        or nil
    hl.workspace_rule({
        workspace = tostring(i),
        monitor = monitor,
        default = true,
        persistent = true,
        default_name = default_name,
        layout = (i == 3 or i == 4) and "scrolling" or nil,
    })
end
