
from libqtile.config import Key
from libqtile.command import lazy

win = 'mod4'
alt = 'mod1'
terminal = 'alacritty'
menu = 'rofi -show drun'
fileManager = 'nemo'

keys = [
    # Moverse entre ventanas
    Key([win], 'Left', lazy.layout.left(), desc='Move focus to left'),
    Key([win], 'Right', lazy.layout.right(), desc='Move focus to right'),
    Key([win], 'Down', lazy.layout.down(), desc='Move focus down'),
    Key([win], 'Up', lazy.layout.up(), desc='Move focus up'),
    Key([win], 'space', lazy.layout.next(),
        desc='Move window focus to other window'),

    # Reacomodar ventanas
    Key([win, 'shift'], 'Left', lazy.layout.shuffle_left(),
        desc='Move window to the left'),
    Key([win, 'shift'], 'Right', lazy.layout.shuffle_right(),
        desc='Move window to the right'),
    Key([win, 'shift'], 'Down', lazy.layout.shuffle_down(), desc='Move window down'),
    Key([win, 'shift'], 'Up', lazy.layout.shuffle_up(), desc='Move window up'),

    # Redimensionar Ventanas
    Key([win, 'control'], 'Left', lazy.layout.grow_left(),
        desc='Grow window to the left'),
    Key([win, 'control'], 'Right', lazy.layout.grow_right(),
        desc='Grow window to the right'),
    Key([win, 'control'], 'Down', lazy.layout.grow_down(), desc='Grow window down'),
    Key([win, 'control'], 'Up', lazy.layout.grow_up(), desc='Grow window up'),

    # stacks
    Key([alt], 'Tab', lazy.layout.down()),

    Key([alt, 'shift'], 'Tab', lazy.layout.up()),

    # next layout
    Key([win], 'space', lazy.next_layout(),
        desc='Toggle between layouts'),

    # fullscreen
    Key(
        [win],
        'f',
        lazy.window.toggle_fullscreen(),
        desc='Toggle fullscreen on the focused window',
    ),

    # floating
    Key([win], 't', lazy.window.toggle_floating(),
        desc='Toggle floating on the focused window'),

    # Launchs
    Key([win], 'Return', lazy.spawn(terminal), desc='Launch terminal'),
    Key([win], 'q', lazy.window.kill(), desc='Kill focused window'),
    Key([win, 'control'], 'r', lazy.reload_config(), desc='Reload the config'),
    Key([win, 'control'], 'q', lazy.shutdown(), desc='Shutdown Qtile'),
    Key([win], 'r', lazy.spawn(menu), desc='Launch rofi'),
    Key([win], 'e', lazy.spawn(fileManager), desc='Launch Nemo'),
    Key([win], 'Tab', lazy.spawn('rofi -show window')),
    Key([win], 'l', lazy.spawn('betterlockscreen -l')),
    Key([win], 'BackSpace', lazy.spawn('/home/vrivera/.local/bin/powermenu')),
    Key([win], 'V', lazy.spawn('clipmenu')),

    # Screenshot
    Key([], 'Print', lazy.spawn('/home/vrivera/.local/bin/screenshot select')),
    Key(['shift'], 'Print', lazy.spawn('/home/vrivera/.local/bin/screenshot window')),

    # Brightness
    Key([], "XF86MonBrightnessUp", lazy.spawn("/home/vrivera/.local/bin/brillo up")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("/home/vrivera/.local/bin/brillo down")),

    # Volume
    Key([], "XF86AudioRaiseVolume", lazy.spawn("/home/vrivera/.local/bin/volume up")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("/home/vrivera/.local/bin/volume down")),
    Key([], "XF86AudioMute", lazy.spawn("/home/vrivera/.local/bin/volume mute")),
]
