HOST_NAME = "desktop"
HOST_MONITOR1 = "DP-1"
HOST_MONITOR2 = "HDMI-A-1"
HOST_PRIMARY_MONITOR = HOST_MONITOR1
HOST_TOTAL_WORKSPACES = 10
HOST_WORKSPACE_NAMES = {
    [1] = "󰖟",
    [2] = "󰖟",
    [3] = "",
    [4] = "",
    [8] = "",
    [9] = "󰓇",
}
HOST_SCROLLING_WORKSPACES = {
    [3] = true,
    [4] = true,
}

HOST_MONITORS = {
    {
        output = "DP-1",
        mode = "1920x1080@144",
        position = "1920x0",
        scale = 1,
    },
    {
        output = "HDMI-A-1",
        mode = "1920x1080@144",
        position = "0x0",
        scale = 1,
    },
}

HOST_KB_LAYOUT = "us"
HOST_KB_OPTIONS = "compose:caps"
HOST_ACCEL_PROFILE = "flat"
HOST_GESTURES = false

HOST_AUTOSTART_COMMANDS = {
    "uwsm app -- zen-browser",
    "uwsm app -- vesktop",
    "uwsm app -- betterbird",
    "uwsm app -- obsidian",
    "uwsm app -- spotify-launcher",
    "xhost +SI:localuser:root",
}
