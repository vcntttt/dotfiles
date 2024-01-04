from libqtile import bar, widget, qtile
from .keys import terminal
from .theme import colors, barFont
from customWidgets.spotify import Spotify

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

statsColors = {
    'background': colors['blue'],
    'foreground': colors['foreground'],
}

# Widgets - Inspiration: https://gitlab.com/dwt1/dotfiles/-/blob/master/.config/qtile/config.py?ref_type=heads
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
                fontsize=20,
                padding=5
            ),
            widget.WindowName(
                font=barFont,
                fontsize=14,
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
                fontsize=14,
                padding=10,
                background=colors['spotify'],
                foreground=colors['background'],
            ),
            widget.CurrentLayout(
                **constrastColors,
                font=barFont,
                fontsize=14,
                padding=8
            ),
            widget.Sep(
                linewidth=0,
                padding=2
            ),
            widget.KeyboardLayout(
                **constrastColors,
                fmt='⌨  Kbd: {}',
                padding=5,
                ),
            widget.Spacer(
                **statsColors,
                length=5
            ),
            widget.CPU(
                **statsColors,
                format='▓  CPU: {load_percent}%',
                mouse_callbacks={
                    'Button1': lambda: qtile.cmd_spawn(terminal + ' -e btop')
                },
                padding=5
            ),
            widget.Memory(
                **statsColors,
                format='🖥  Mem: {MemUsed: .0f}{mm}',
                mouse_callbacks={
                    'Button1': lambda: qtile.cmd_spawn(terminal + ' -e btop')
                },
                padding=5
            ),
            widget.Volume(
                **statsColors,
                fmt='🕫  Vol: {}',
                mouse_callbacks={
                    'Button1': lambda: qtile.cmd_spawn('pavucontrol')
                },
                padding=5

            ),
            widget.DF(
                **statsColors,
                visible_on_warn=False,
                update_interval=60,
                mouse_callbacks={
                    'Button1': lambda: qtile.cmd_spawn(terminal + ' -e df')},
                partition='/',
                # format = '[{p}] {uf}{m} ({r:.0f}%)',
                format='{uf}{m} free',
                fmt='🖴  Disk: {}',
                padding=5
            ),
            widget.Battery(
                **statsColors,
                format='{char} {percent:2.0%}',
                update_interval=10,
                discharge_char='',
                full_char='',
                charge_char='',
                empty_char='',
                padding=5
            ),
            widget.Clock(
                **statsColors,
                format="⏱  %a, %d %b -- %H:%M",
                padding=5
            ),
            widget.Spacer(
                **statsColors,
                length=5
            ),
            widget.TextBox(
                **constrastColors,
                text='',
                fontsize=16,
                mouse_callbacks={'Button1': lambda: qtile.cmd_spawn(
                    '/home/vrivera/.local/bin/powermenu')},
                padding=8
            )]
    
    if systray:
        widgetList.insert(7,
        widget.Systray(
            padding=7
            
        ))

    return bar.Bar(widgetList, 30)
