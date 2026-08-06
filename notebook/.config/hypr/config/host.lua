HOST_NAME = "notebook"
HOST_MONITOR1 = "eDP-1"
HOST_MONITOR2 = nil
HOST_PRIMARY_MONITOR = HOST_MONITOR1
HOST_WORKSPACES = { 1, 2, 3, 4, 8, 9 }
HOST_WORKSPACE_NAMES = {
    [1] = "󰖟",
    [8] = "",
    [9] = "󰓇",
}

HOST_MONITORS = {
    {
        output = "eDP-1",
        mode = "preferred",
        position = "auto",
        scale = 1.5,
    },
}

HOST_KB_LAYOUT = "latam"
HOST_KB_OPTIONS = "compose:caps"
HOST_ACCEL_PROFILE = "adaptive"
HOST_TOUCHPAD = {
    natural_scroll = true,
    scroll_factor = 0.4,
}
HOST_GESTURES = true

HOST_AUTOSTART_COMMANDS = {
    "uwsm app -- zen-browser",
    "uwsm app -- betterbird",
}
