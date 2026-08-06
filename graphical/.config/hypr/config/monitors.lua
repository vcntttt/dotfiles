-- Monitor wiki https://wiki.hypr.land/Configuring/Basics/Monitors/
-- Monitor values live in the selected host package.
for _, monitor in ipairs(HOST_MONITORS or {}) do
    hl.monitor(monitor)
end
