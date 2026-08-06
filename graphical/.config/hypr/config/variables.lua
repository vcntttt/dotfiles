-- Hyprland default apps

TERMINAL     = "ghostty"
FILE_MANAGER = "dolphin"
BROWSER      = "zen-browser"
EDITOR       = "gnome-text-editor --new-window"
CALCULATOR   = "gnome-calculator"

-- Monitors are supplied by the selected host package.
MONITOR1 = HOST_MONITOR1 or "eDP-1"
MONITOR2 = HOST_MONITOR2
PRIMARY_MONITOR = HOST_PRIMARY_MONITOR or MONITOR1

-- Workspaces
WORKSPACES_PER_MONITOR = 5
TOTAL_WORKSPACES = HOST_TOTAL_WORKSPACES or WORKSPACES_PER_MONITOR * (MONITOR2 and 2 or 1)
