-- Auto-start config
-- if you dont use UWSM add your auto start programs here, otherwise use XDG autostart https://wiki.archlinux.org/title/XDG_Autostart

hl.on("hyprland.start", function ()
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")
    hl.exec_cmd("env LC_ALL= LC_TIME=es_CL.UTF-8 noctalia")
    hl.exec_cmd("noctalia-active-monitor-notifications")

    for _, command in ipairs(HOST_AUTOSTART_COMMANDS or {}) do
        hl.exec_cmd(command)
    end

    -- Dejar el foco final en el workspace principal.
    hl.timer(function ()
        hl.dispatch(hl.dsp.focus({ workspace = "1" }))
    end, { timeout = 3000, type = "oneshot" })
end)
