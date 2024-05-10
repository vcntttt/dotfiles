from libqtile.config import Key
from libqtile.command import lazy

win = 'mod4'
alt = 'mod1'
terminal = 'warp-terminal'
fileManager = 'nemo'

keys = [
    # Moverse entre ventanas
    Key([win], 'l', lazy.layout.left(), desc='Move focus to left'),
    Key([win], 'h', lazy.layout.right(), desc='Move focus to right'),
    Key([win], 'j', lazy.layout.down(), desc='Move focus down'),
    Key([win], 'k', lazy.layout.up(), desc='Move focus up'),
    Key([win], 'space', lazy.layout.next(),
        desc='Move window focus to other window'),

    # Reacomodar ventanas
    Key([win, 'shift'], 'l', lazy.layout.shuffle_left(),
        desc='Move window to the left'),
    Key([win, 'shift'], 'h', lazy.layout.shuffle_right(),
        desc='Move window to the right'),
    Key([win, 'shift'], 'j', lazy.layout.shuffle_down(), desc='Move window down'),
    Key([win, 'shift'], 'k', lazy.layout.shuffle_up(), desc='Move window up'),

    # Redimensionar Ventanas
    Key([win, 'control'], 'l', lazy.layout.grow_left(),
        desc='Grow window to the left'),
    Key([win, 'control'], 'h', lazy.layout.grow_right(),
        desc='Grow window to the right'),
    Key([win, 'control'], 'j', lazy.layout.grow_down(), desc='Grow window down'),
    Key([win, 'control'], 'k', lazy.layout.grow_up(), desc='Grow window up'),

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
    Key([win], 'Tab', lazy.spawn('rofi -show window')),
    Key([alt], 'l', lazy.spawn('betterlockscreen -l')),
    Key([win], 'BackSpace', lazy.spawn('/home/vrivera/.local/bin/powermenu')),
    Key([win], 'v', lazy.spawn('rofi -modi "clipboard:greenclip print" -show clipboard -run-command "{cmd}"')),
    Key([win], 'e', lazy.spawn('nemo'), desc='launch nemo'),
    
    # Rofi
    Key([alt], 'space', lazy.spawn('rofi -show drun'), desc='Launch rofi'),
    Key([win], 'period', lazy.spawn('rofi -show emoji'), desc='Launch rofi'),
    Key([win, 'shift'], 's', lazy.spawn('rofi -show ssh'), desc='Launch rofi'),
    Key([alt, 'control'], 'Return', lazy.spawn('/home/vrivera/dev/rofi-todoist/rofi-todoist.sh'), desc='Launch rofi'),
    Key([win, alt], 'L', lazy.spawn('betterlockscreen -l'), desc='Launch powermenu'),
    Key([win, alt], 'space', lazy.spawn('/home/vrivera/.local/bin/keyboard'), desc='Launch keyboard menu'),
    
    # Screenshot
#   Key([], 'Print', lazy.spawn('/home/vrivera/.local/bin/screenshot select')),
#   Key(['shift'], 'Print', lazy.spawn('/home/vrivera/.local/bin/screenshot window')),

    Key([], 'Print', lazy.spawn('flameshot gui')),
    Key(['shift'], 'Print', lazy.spawn('flameshot screen')),

    # Brightness
    Key([], "XF86MonBrightnessUp", lazy.spawn("/home/vrivera/.local/bin/brillo up")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("/home/vrivera/.local/bin/brillo down")),

    # Volume
    Key([], "XF86AudioRaiseVolume", lazy.spawn("/home/vrivera/.local/bin/volume up")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("/home/vrivera/.local/bin/volume down")),
    Key([], "XF86AudioMute", lazy.spawn("/home/vrivera/.local/bin/volume mute")),
]
