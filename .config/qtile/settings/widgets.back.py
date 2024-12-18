from libqtile import bar, qtile
from .keys import powermenu
from .theme import *
from qtile_extras import widget
from qtile_extras.widget.decorations import PowerLineDecoration

# Widgets
widget_defaults = dict(
    font='Roboto',
    fontsize=12,
    padding=3,
)

extension_defaults = widget_defaults.copy()

statsColors2 = {
    'background': foregroundColor,
    'foreground': backgroundColor,
}

statsColors1 = {
    'background': backgroundColor,
    'foreground': foregroundColor,
}

powerline = {
    "decorations": [
        PowerLineDecoration(path="arrow_right")
    ],
}
terminal = "alacritty"


def statusBar(systray=False):
    widgetList = [
        widget.Spacer(length=5),
        widget.Spacer(length=5),
        widget.GroupBox(
            fontsize=16,
            margin_x=10,
            margin_y=4,
            padding_x=6,
            padding_y=6,
            borderwidth=5,
            background=colors["foreground"],
            highlight_method='line',
            highlight_color=[colors['foreground']],
            foreground='#000000',
            other_screen_border=colors['other_screen_group'],
            other_current_screen_border=colors['other_screen_group'],
            rounded=True,
            this_current_screen_border=colors['active_group'],
            inactive=colors['inactiveGroup'],
            active=colors['dark'],
        ),
        widget.WindowName(
            background=colors['dark'],
            foreground=colors['foreground'],
            font=statsFont,
            fontsize=12,
            max_chars=50,
            width=400,
            padding=10
        ),
        widget.Spacer(
            background=colors['dark'],
        ),
        widget.CurrentLayout(
            **statsColors2,
            **powerline,
            padding=8,
            font=statsFont,
            fontsize=12,
        ),
        widget.KeyboardLayout(
            **statsColors2,
            **powerline,
            configured_keyboards=['us', 'us intl', 'latam'],
            display_map={'us': 'US', 'us intl': 'US INT', 'latam': 'LATAM'},
            fmt='⌨ : {}',
            padding=5,
            font=statsFont,
            fontsize=12
        ),
        widget.ThermalSensor(
            format=" {temp:.0f}{unit}",
            **statsColors1,
            **powerline,
            update_interval=2,
            padding=5,
        ),
        widget.TextBox(
            **statsColors2,
            text='󰍛',
            font=statsFont,
            fontsize=16,
        ),
        widget.CPU(
            **statsColors2,
            **powerline,
            # format="  {freq_current}GHz {load_percent}%",
            format="{freq_current}GHz {load_percent}%",
            # format='CPU: {load_percent}% ',
            # mouse_callbacks={
            #     'Button1': lambda: qtile.spawn(terminal + ' -e btop')
            # },
            padding=5,
            font=statsFont,
            fontsize=12,
        ),
        widget.Memory(
            **statsColors1,
            **powerline,
            format="   {MemUsed:.0f}{mm} ",
            # format='{MemUsed: .0f}{mm} ',
            # mouse_callbacks={
            #     'Button1': lambda: qtile.spawn(terminal + ' -e btop')
            # },
            padding=5,
            font=statsFont,
            fontsize=12,
        ),
        widget.DF(
            **statsColors2,
            **powerline,
            visible_on_warn=False,
            update_interval=60,
            # mouse_callbacks={
            #     'Button1': lambda: qtile.spawn(terminal + ' -e df')},
            partition='/',
            format='  {uf}{m}/{s}G free ',
            fmt='{}',
            padding=5,
            font=statsFont,
            fontsize=12,
        ),
        # widget.CheckUpdates(
        #     **statsColors2,
        #     **powerline,
        #     colour_have_updates='#121212',
        #     colour_no_updates='#121212',
        #     display_format=':  {updates}',
        #     distro="Arch",
        #     execute='alacritty -e /usr/bin/yay -Syu',
        #     no_update_string=' ',
        #     padding=4,
        #     update_interval=60
        # ),
        # widget.TextBox(
        #     **statsColors1,
        #     text='\uf017 ',
        #     font=statsFont,
        #     fontsize=18,
        # ),
        widget.Clock(
            **statsColors1,
            **powerline,
            format="  %a %d %b - %H:%M",
            padding=5,
            font=statsFont,
            fontsize=12,
        ),
        widget.TextBox(
            **statsColors2,
            text='',
            mouse_callbacks={'Button1': lambda: qtile.spawn(powermenu)},
            padding=8,
            font=statsFont,
            fontsize=14,
        ),
        widget.Spacer(
            **statsColors2,
            length=5,
        )]

    if systray:
        widgetList.insert(6, widget.Systray(
            **statsColors1, padding=10))
        widgetList.insert(7, widget.Spacer(**statsColors1, length=10))

    return bar.Bar(widgetList, 30)
