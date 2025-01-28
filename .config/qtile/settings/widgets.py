from libqtile import bar, qtile
from .keys import powermenu
from qtile_extras import widget
from .theme import catpuccin, fontsize
from qtile_extras.widget.decorations import RectDecoration

# Widgets
widget_defaults = dict(
    font="JetBrainsMono Nerd Font",
    fontsize=15,
    padding=2,
    background=catpuccin["bg"],
)


def _left_decor(color: str, padding_x=None, padding_y=4, round=False):
    radius = 4 if round else [4, 0, 0, 4]
    return [
        RectDecoration(
            colour=color,
            radius=radius,
            filled=True,
            padding_x=padding_x,
            padding_y=padding_y,
        )
    ]


def _right_decor(round=False):
    radius = 4 if round else [0, 4, 4, 0]
    return [
        RectDecoration(
            colour=catpuccin["darkgray"],
            radius=radius,
            filled=True,
            padding_y=4,
            padding_x=0,
        )
    ]


spacer = widget.Spacer(length=5)

extension_defaults = widget_defaults.copy()


def statusBar(systray=False):
    widgetList = [
        widget.Spacer(
            background=catpuccin["blue"],
            length=5,
        ),
        widget.GroupBox(
            active=catpuccin["blue"],
            inactive=catpuccin["gray"],
            this_current_screen_border=catpuccin["blue"],
            this_screen_border=catpuccin["blue"],
            other_current_screen_border=catpuccin["bg"],
            other_screen_border=catpuccin["bg"],
            urgent_border=catpuccin["red"],
            background=catpuccin["bg"],
            highlight_color=catpuccin["darkgray"],
            highlight_method="line",
            rounded=False,
            disable_drag=True,
            fontsize=16,
            borderwidth=2,
            padding_x=10,
            padding_y=5,
        ),
        spacer,
        spacer,
        widget.CurrentLayout(
            padding=8,
            fontsize=fontsize,
            decorations=_right_decor(),
        ),
        widget.WindowName(fontsize=fontsize, max_chars=60, width=500, padding=10),
        widget.Spacer(),
        spacer,
        widget.KeyboardLayout(
            configured_keyboards=["us", "us intl", "latam"],
            display_map={"us": "US", "us intl": "US INT", "latam": "LATAM"},
            fmt="⌨ : {}",
            padding=5,
            fontsize=fontsize,
            decorations=_right_decor(),
        ),
        spacer,
        widget.ThermalSensor(
            format=" {temp:.0f}{unit}",
            update_interval=2,
            padding=5,
            fontsize=fontsize,
            decorations=_right_decor(),
        ),
        spacer,
        widget.CPU(
            # format="  {freq_current}GHz {load_percent}%",
            format="󰍛 {freq_current}GHz {load_percent}%",
            # format='CPU: {load_percent}% ',
            # mouse_callbacks={
            #     'Button1': lambda: qtile.spawn(terminal + ' -e btop')
            # },
            padding=5,
            fontsize=fontsize,
            decorations=_right_decor(),
            foreground=catpuccin["red"],
        ),
        spacer,
        widget.Memory(
            format="   {MemUsed:.0f}{mm} ",
            # format='{MemUsed: .0f}{mm} ',
            # mouse_callbacks={
            #     'Button1': lambda: qtile.spawn(terminal + ' -e btop')
            # },
            padding=5,
            fontsize=fontsize,
            decorations=_right_decor(),
            foreground=catpuccin["yellow"],
        ),
        spacer,
        widget.DF(
            foreground=catpuccin["green"],
            visible_on_warn=False,
            update_interval=60,
            # mouse_callbacks={
            #     'Button1': lambda: qtile.spawn(terminal + ' -e df')},
            partition="/",
            # format='  {uf}{m}/{s}G free ',
            format="  {uf}G",
            fmt="{}",
            padding=5,
            fontsize=fontsize,
            decorations=_right_decor(),
        ),
        spacer,
        widget.Clock(
            format="  %a %d %b - %H:%M",
            foreground=catpuccin["fg"],
            padding=8,
            fontsize=fontsize,
            decorations=_right_decor(),
            # mouse_callbacks={'Button1': lambda: qtile.spawn(calendar)},
        ),
        spacer,
        widget.TextBox(
            text="",
            background=catpuccin["blue"],
            foreground=catpuccin["black"],
            fontsize=18,
            padding=12,
            mouse_callbacks={"Button1": lambda: qtile.spawn(powermenu)},
        ),
        widget.Spacer(
            background=catpuccin["blue"],
            length=5,
        ),
    ]

    if systray:
        widgetList.insert(8, widget.Systray(padding=10))
        widgetList.insert(9, widget.Spacer(length=10))

    return bar.Bar(widgetList, 30)
