from libqtile import bar, qtile
from .keys import terminal
from .theme import colors, barFont, DoomOne
from customWidgets.spotify import Spotify
import subprocess
from qtile_extras import widget
from qtile_extras.widget.decorations import PowerLineDecoration

# Widgets
widget_defaults = dict(
    font="Roboto",
    fontsize=12,
    padding=3,
)

extension_defaults = widget_defaults.copy()

constrastColors = {
    'foreground': colors["dark"],
    'background': colors["foreground"],
}

statsColors2 = {
    'background': "#ddd",
    'foreground': "#121212",
}

statsColors1 = {
    'background': "#121212",
    'foreground': "#ddd",
}

powerline = {
    "decorations": [
        PowerLineDecoration(path="arrow_right")
    ],
}

statsFont = "JetBrainsMono Nerd Font"


def my_bar(systray=False):
    widgetList = [
        widget.Spacer(length=5),
        widget.Image(
            filename="~/pictures/arch-icon.svg",
            scale="False",
            margin=4,
        ),
        widget.Spacer(length=5),
        widget.GroupBox(
            background=colors["foreground"],
            highlight_method='line',
            highlight_color=[colors['foreground']],
            foreground='#000000',
            other_screen_border=colors['red'],
            other_current_screen_border=colors['red'],
            rounded=True,
            this_current_screen_border=colors['blue'],
            inactive=colors['inactiveGroup'],
            active=colors['dark'],
            fontsize=18,
            padding=8
        ),
        # widget.Spacer(length=5, background=colors["foreground"]),
        widget.WindowName(
            font=statsFont,
            fontsize=12,
            max_chars=50,
            width=400,
            padding=10
        ),
        widget.Spacer(),
        # --------------------------------------------------------------------------#
        # -------------------------------Lado Derecho-------------------------------#
        # --------------------------------------------------------------------------#
        Spotify(
            font=barFont,
            fontsize=12,
            padding=10,
            background=colors['spotify'],
            foreground=colors['background'],
        ),
        widget.CurrentLayout(
            **statsColors2,
            **powerline,
            padding=8,
            font=statsFont,
            fontsize=12,
        ),
        widget.KeyboardLayout(
            **statsColors1,
            **powerline,
            fmt='⌨ : {}',
            padding=5,
            font=statsFont,
            fontsize=12,
        ),
        widget.ThermalSensor(
            **statsColors2,
            **powerline,
            update_interval=2,
            padding=5,
        ),
        widget.CPU(
            **statsColors1,
            **powerline,
            format='CPU: {load_percent}% ',
            mouse_callbacks={
                'Button1': lambda: qtile.cmd_spawn(terminal + ' -e btop')
            },
            padding=5,
            font=statsFont,
            fontsize=12,
        ),
        widget.Memory(
            **statsColors2,
            **powerline,
            format='🖥 : {MemUsed: .0f}{mm} ',
            mouse_callbacks={
                'Button1': lambda: qtile.cmd_spawn(terminal + ' -e btop')
            },
            padding=5,
            font=statsFont,
            fontsize=12,
        ),
        # widget.Volume(
        #     **statsColors2,
        #     **powerline,
        #     fmt='🕫  Vol: {}',
        #     mouse_callbacks={
        #         'Button1': lambda: qtile.cmd_spawn('pavucontrol')
        #     },
        #     padding=5

        # ),
        widget.DF(
            **statsColors1,
            **powerline,
            visible_on_warn=False,
            update_interval=60,
            mouse_callbacks={
                'Button1': lambda: qtile.cmd_spawn(terminal + ' -e df')},
            partition='/',
            format='{uf}{m} free',
            fmt='🖴 : {}',
            padding=5,
            font=statsFont,
            fontsize=12,
        ),
        widget.Battery(
            **statsColors2,
            **powerline,
            format='{char} {percent:2.0%}',
            update_interval=10,
            discharge_char='',
            full_char='',
            charge_char='',
            empty_char='',
            padding=8,
            font=statsFont,
            fontsize=12,
        ),
        widget.TextBox(
            **statsColors1,
            text='\uf017 ',
            font=statsFont,
            fontsize=18,
        ),
        widget.Clock(
            **statsColors1,
            **powerline,
            format="%a, %d %b - %H:%M",
            padding=5,
            font=statsFont,
            fontsize=12,
        ),
        widget.TextBox(
            **constrastColors,
            text='',
            mouse_callbacks={'Button1': lambda: qtile.cmd_spawn(
                '/home/vrivera/.local/bin/powermenu')},
            padding=8,
            font=barFont,
            fontsize=16,
        ),
        widget.Spacer(
            length=5,
            **constrastColors,
        )]

    if systray:
        widgetList.insert(6, widget.Systray(padding=10))
        widgetList.insert(7, widget.Spacer(length=10, background=colors['background']))

    # else:
    #     widgetList.insert(8,
    #                       widget.Sep(
    #                           linewidth=0,
    #                           padding=3,
    #                       ),)
        
    return bar.Bar(widgetList, 30)
