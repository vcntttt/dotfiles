from libqtile import bar, qtile
from .keys import terminal
from .theme import colors, statsFont
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
    'background': colors['foreground'],
    'foreground': colors['background'],
}

statsColors1 = {
    'background': colors['background'],
    'foreground': colors['foreground'],
}

powerline = {
    "decorations": [
        PowerLineDecoration(path="arrow_right")
    ],
}

def my_bar(systray=False):
    widgetList = [
        widget.Spacer(length=5),
        widget.Spacer(length=5),
        widget.GroupBox(
            **statsColors1,
            padding_x=10,
            fontsize=16,
            active='#f1ffff',
            inactive='#4c566a',
            rounded=False,
            highlight_method='block',
            urgent_alert_method='block',
            urgent_border='#F07178',
            this_current_screen_border='#a151d3',
            this_screen_border="#353c4a",
            other_current_screen_border='#353c4a',
            other_screen_border='#353c4a',
            disable_drag=True
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
            **statsColors1,
            **powerline,
            configured_keyboards=['us', 'us intl', 'latam'],
            display_map={'us': 'US', 'us intl': 'US INT', 'latam': 'LATAM'},
            fmt='⌨ : {}',
            padding=5,
            font=statsFont,
            fontsize=12
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
                'Button1': lambda: qtile.spawn(terminal + ' -e btop')
            },
            padding=5,
            font=statsFont,
            fontsize=12,
        ),
        widget.Memory(
            **statsColors2,
            **powerline,
            format='{MemUsed: .0f}{mm} ',
            mouse_callbacks={
                'Button1': lambda: qtile.spawn(terminal + ' -e btop')
            },
            padding=5,
            font=statsFont,
            fontsize=12,
        ),
        widget.DF(
            **statsColors1,
            **powerline,
            visible_on_warn=False,
            update_interval=60,
            mouse_callbacks={
                'Button1': lambda: qtile.spawn(terminal + ' -e df')},
            partition='/',
            format='{uf}{m} free',
            fmt='{}',
            padding=5,
            font=statsFont,
            fontsize=12,
        ),
        widget.CheckUpdates(
            **statsColors2,
            **powerline,
            colour_have_updates='#121212',
            colour_no_updates='#121212',
            display_format=':  {updates}',
            distro="Arch_yay",
            execute='alacritty -e /usr/bin/yay -Syu',
            no_update_string=' ',
            padding=4,
            update_interval=60
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
            **statsColors2,
            text='',
            mouse_callbacks={'Button1': lambda: qtile.spawn(
                '/home/vrivera/.local/bin/powermenu')},
            padding=8,
            font=statsFont,
            fontsize=16,
        ),
        widget.Spacer(
            **statsColors2,
            length=5,
        )]

    if systray:
        widgetList.insert(6, widget.Systray(
            **statsColors1, padding=10))
        widgetList.insert(7, widget.Spacer( **statsColors1, length=10))

        #    else:
        #        widgetList.insert(6,widget.Pomodoro(
        #                                **statsColors1,
        #                                prefix_inactive="Pomodoro",
        #                                fontsize=12,
        #                                font=statsFont,
    #                            ))


    return bar.Bar(widgetList, 30)
