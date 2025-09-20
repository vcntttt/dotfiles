from libqtile.config import Key
from libqtile.lazy import lazy

win = 'mod4'
alt = 'mod1'
terminal = 'warp-terminal'
fileManager = 'nemo'
powermenu = "rofi -show menu -modi 'menu:~/.local/bin/rofi-power-menu --choices=shutdown/reboot/lockscreen/suspend/logout' -config ~/.config/rofi/power.rasi"

keys = [
    # Moverse entre ventanas
    Key([win], 'l', lazy.layout.left(), desc='Move focus to left'),
    Key([win], 'h', lazy.layout.right(), desc='Move focus to right'),
    Key([win], 'j', lazy.layout.down(), desc='Move focus down'),
    Key([win], 'k', lazy.layout.up(), desc='Move focus up'),
    # Key([win], 'space', lazy.layout.next(),
    #     desc='Move window focus to other window'),

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
    Key([win], 'space', lazy.spawn('/home/vrivera/dotfiles/.local/bin/rofi-qtile-layout-switcher'),
        desc='Launch Rofi Qtile layout switcher'),

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
    Key([win], "BackSpace", lazy.spawn(powermenu), desc="Launch powermenu"),
    Key([win], 'v', lazy.spawn('rofi -modi "clipboard:greenclip print" -show clipboard -run-command "{cmd}"')),
    Key([win], 'e', lazy.spawn(fileManager), desc='launch file manager'),
    
    # Rofi
    Key([win, 'shift'], 'Return', lazy.spawn('rofi -show drun'), desc='Launch rofi menu apps'),
    Key([win], 'r', lazy.spawn('rofi -show run'), desc='Launch rofi scripts'),
    Key([win], 'period', lazy.spawn('rofi -show emoji'), desc='Launch rofi emoji'),
    Key([win, 'shift'], 's', lazy.spawn('rofi -show ssh'), desc='Launch rofi ssh'),
    # Key([alt, 'control'], 'Return', lazy.spawn('/home/vrivera/dev/rofi-todoist/rofi-todoist.sh'), desc='Launch rofi'),
    Key([win, alt], 'L', lazy.spawn('betterlockscreen -l'), desc='Launch rofi powermenu'),
    Key([win, alt], 'space', lazy.spawn('/home/vrivera/.local/bin/keyboard'), desc='Launch keyboard menu'),
    Key([win], 'c', lazy.spawn('rofi -show calc -modi calc -no-show-match -no-sort > /dev/null'), desc='Launch rofi-calc'),
    
    # Screenshot
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
