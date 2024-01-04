# Vicente Rivera - 2023
from typing import List
import subprocess
from os import path
from libqtile import bar, layout, widget, hook, qtile
from libqtile.config import Click, Drag, Group, ScratchPad, DropDown, Key, Match, Screen
from libqtile.lazy import lazy
from qtile_extras.widget.decorations import PowerLineDecoration

win = "mod4"
alt = "mod1"
terminal = "alacritty"
menu = "rofi -show drun"
fileManager = "nemo"
keys = [
    # Switch between windows
    Key([win], "Left", lazy.layout.left(), desc="Move focus to left"),
    Key([win], "Right", lazy.layout.right(), desc="Move focus to right"),
    Key([win], "Down", lazy.layout.down(), desc="Move focus down"),
    Key([win], "Up", lazy.layout.up(), desc="Move focus up"),
    Key([win], "space", lazy.layout.next(),
        desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([win, "shift"], "Left", lazy.layout.shuffle_left(),
        desc="Move window to the left"),
    Key([win, "shift"], "Right", lazy.layout.shuffle_right(),
        desc="Move window to the right"),
    Key([win, "shift"], "Down", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([win, "shift"], "Up", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([win, "control"], "Left", lazy.layout.grow_left(),
        desc="Grow window to the left"),
    Key([win, "control"], "Right", lazy.layout.grow_right(),
        desc="Grow window to the right"),
    Key([win, "control"], "Down", lazy.layout.grow_down(), desc="Grow window down"),
    Key([win, "control"], "Up", lazy.layout.grow_up(), desc="Grow window up"),
    # Key([win, "shift"], "n", lazy.layout.normalize(),desc="Reset all window sizes"),

    Key(
        [win, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([win], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([win, "control"], "Tab", lazy.next_layout(),
        desc="Toggle between layouts"),
    Key([win], "q", lazy.window.kill(), desc="Kill focused window"),
    Key(
        [win],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key([win], "t", lazy.window.toggle_floating(),
        desc="Toggle floating on the focused window"),
    Key([win, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([win, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([win], "r", lazy.spawn(menu), desc="Launch rofi"),
    Key([win], "e", lazy.spawn(fileManager), desc="Launch Nemo"),
    Key([alt], "Tab", lazy.spawn("rofi -show window")),
    Key([win], "l", lazy.spawn("betterlockscreen -l")),
    Key([win], "BackSpace", lazy.spawn("/home/vrivera/.local/bin/powermenu")),
]

groups = []

groupsNames = ["1", "2", "3", "4", "5", "6", "7", "8"]

# Estos son los que hay que winificar
groupsLabels = ["", "", "3", "4", "5", "6", "7", "8"]

# groupsLayouts = [] En caso de que quiera dejar layouts por defecto en cada workspace

for i in range(len(groupsNames)):
    groups.append(Group(
        name=groupsNames[i],
        label=groupsLabels[i]
    ))

for i in groups:
    keys.extend(
        [
            Key(
                [win],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="win + Number to move to that group",
            ),
            Key(
                [win, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Move focused windows to respective workspace",
            ),
        ]
    )

keys.extend([
    Key(
        [win],
        "Tab",
        lazy.screen.next_group(),
        desc="Move to next group with the tab",
    ),
    Key(
        [win, "shift"],
        "Tab",
        lazy.screen.prev_group(),
        desc="Move to prev group with the tab",
    ),
])

bordersConfig = {
    'margin': 0,
    "border_focus": "#7f849c",
    "border_normal": "#313244"
}

layouts = [
    layout.Columns(**bordersConfig),
    layout.Max(),
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    layout.MonadTall(**bordersConfig),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

# ScratchPads
groups.append(ScratchPad("scratchpad", [
    DropDown("term", "alacritty --class=scratch", width=0.8, height=0.8, x=0.1, y=0.1, opacity=0.9),
    DropDown("btop", "alacritty --class=btop -e btop", width=0.8, height=0.8, x=0.1, y=0.1, opacity=0.9),
    # DropDown("nemo", "nemo", width=0.8, height=0.8, x=0.1, y=0.1, opacity=0.9),
]))

keys.extend([
    Key([win, "shift"], "Return", lazy.group['scratchpad'].dropdown_toggle('term')),
    Key([win], "b", lazy.group['scratchpad'].dropdown_toggle('btop')),
    # Key([win], "n", lazy.group['scratchpad'].dropdown_toggle('nemo')),
])

# Widgets
widget_defaults = dict(
    font="Roboto Regular",
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()

colors = {
    "background": "#0E1415",
    "foreground": "#CECECE",
    "primary": "#88DB3F",
    "secondary": "4AC9E2",
    "alert": "#F36868"
}

# --------------------------------------------------------
# Decorations
# https://qtile-extras.readthedocs.io/en/stable/manual/how_to/decorations.html
# --------------------------------------------------------

decor_left = {
    "decorations": [
        PowerLineDecoration(
            path="arrow_left"
            # path="rounded_left"
            # path="forward_slash"
            # path="back_slash"
        )
    ],
}

decor_right = {
    "background": colors["primary"]+".4",
    'foreground': colors["background"],
    "decorations": [
        PowerLineDecoration(
            path="arrow_right"
            # path="rounded_right"
            # path="forward_slash"
            # path="back_slash"
        )
    ],
}


def my_bar():
    return bar.Bar(
        [
            widget.TextBox(
                **decor_left,
                background=colors["background"] +".4",
                text='\uf17c',
                foreground='ffffff',
                desc='',
                padding=10,
                fontsize=20,
                mouse_callbacks={
                    "Button1": lambda: qtile.cmd_spawn("rofi -show drun")},
            ),
# TODO: Finish workspace widget
            widget.GroupBox(
                **decor_left,
                background="#ffffff.7",
                highlight_method='line',
                highlight='#ffffff',
                block_border='#000000',
                block_highlight_text_color='#fff',
                foreground='#000000',
                rounded=True,
                # this_current_screen_border='#98ff55.7',
                active='#000000',
                fontsize=16
            ),
            widget.WindowName(
                **decor_left,
                max_chars=50,
                width=400,
                padding=10
            ),
            widget.Spacer(),
            widget.CurrentLayout(),
            widget.Spacer(
                background=colors["background"] +".4",
                length=5
            ),
            widget.Spacer(
                **decor_right,
                length=10
            ),
            widget.CPU(
                **decor_right,
                format='▓  CPU: {load_percent}%',
                mouse_callbacks={
                    'Button1': lambda: qtile.cmd_spawn(terminal + ' -e btop')
                }
            ),
            widget.Memory(
                **decor_right,
                format='🖥  Mem: {MemUsed: .0f}{mm}',
                mouse_callbacks={
                    'Button1': lambda: qtile.cmd_spawn(terminal + ' -e btop')
                }
            ),
            widget.Volume(
                **decor_right,
                padding=10,
                fmt='Vol: {}',
            ),
            widget.DF(
                **decor_right,
                padding=10,
                visible_on_warn=False,
                format="Disk: {p} {uf}{m} ({r:.0f}%)",
            ),
            widget.Battery(
                **decor_right,
                format='{char} {percent:2.0%}',
                update_interval=10,
                discharge_char='',
                full_char='',
                charge_char='',
                empty_char='',
            ),
            widget.Clock(
                **decor_right,
                padding=10,
                format="⏱  %a, %d %b -- %H:%M",
            )
        ],
        30,
        background=colors["background"]
    )


# Configuración de las pantallas
screens = [
    Screen(bottom=my_bar()),
    Screen(bottom=my_bar()),
    Screen(bottom=my_bar())
]

# screens = [
#     Screen(bottom=bar.Gap(25)),
#     Screen(bottom=bar.Gap(25)),
#     Screen(bottom=bar.Gap(25))
# ]

# Drag floating layouts.
mouse = [
    Drag([win], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([win], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([win], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ],
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

wmname = "qtile"

@hook.subscribe.client_managed
@hook.subscribe.client_killed
def set_gaps(window=None): 
    gap_size = 10  
    for group in qtile.groups:
        if len(group.windows) > 1:
            group.layout.margin = gap_size
        else:
            group.layout.margin = 0
    qtile.current_group.layout_all()
@hook.subscribe.startup_once
def startOnce():
    home = path.expanduser('~')
    subprocess.call([home + '/.config/qtile/autostart.sh'])
