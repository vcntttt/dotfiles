-- Auto-start config
-- if you dont use UWSM add your auto start programs here, otherwise use XDG autostart https://wiki.archlinux.org/title/XDG_Autostart

hl.on("hyprland.start", function ()
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")
    hl.exec_cmd("env LC_ALL= LC_TIME=es_CL.UTF-8 noctalia")
    hl.exec_cmd("/home/vrivera/dotfiles/.local/bin/noctalia-active-monitor-notifications")
    hl.exec_cmd("uwsm app -- zen-browser")
    hl.exec_cmd("uwsm app -- vesktop")
    hl.exec_cmd("uwsm app -- betterbird")
    hl.exec_cmd("uwsm app -- obsidian")
    hl.exec_cmd("uwsm app -- spotify-launcher")
    hl.exec_cmd("xhost +SI:localuser:root")

    -- Dejar el foco final en Zen/workspace 1; workspace 4 queda activo en HDMI-A-1.
    hl.timer(function ()
        hl.dispatch(hl.dsp.focus({ workspace = "1" }))
    end, { timeout = 3000, type = "oneshot" })
end)
