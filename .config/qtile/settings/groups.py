from libqtile.config import Group, Key, ScratchPad, DropDown
from libqtile.lazy import lazy
from .keys import keys, win
from libqtile.dgroups import simple_key_binder

groups = []
groupsNames = ['1', '2', '3', '4', '5', '6', '7', '8', '9']
groupsLabels = ["", '', '', '', '󰕧', '', '', '', '']
groupsLayouts = ['max', 'max', 'max', 'max', 'max',
                 'monadtall', 'monadtall', 'monadtall', 'monadtall']

groupSpawn = {
    '1': ['zen-browser'],
    '2': ['warp-terminal'],
    '3': ['obsidian'],
    '4': ['telegram-desktop', 'mailspring --password-store="gnome-libsecret"', 'vesktop']
}

for name, label, layout in zip(groupsNames, groupsLabels, groupsLayouts):
    groups.append(Group(
        name=name,
        label=label,
        layout=layout,
        spawn=groupSpawn.get(name, [])
    ))

for i in groups:
    keys.extend(
        [
            Key(
                [win],
                i.name,
                lazy.group[i.name].toscreen(),
                desc='win + Number to move to that group',
            ),
            Key(
                [win, 'shift'],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc='Move focused windows to respective workspace',
            ),
        ]
    )

# keys.extend([
#     Key(
#         [win],
#         'Tab',
#         lazy.screen.next_group(),
#         desc='Move to next group with the tab',
#     ),
#     Key(
#         [win, 'shift'],
#         'Tab',
#         lazy.screen.prev_group(),
#         desc='Move to prev group with the tab',
#     ),
# ])

# ScratchPads
conf = {
    'width': 0.8,
    'height': 0.8,
    'x': 0.1,
    'y': 0.1,
    'opacity': 0.9,
    'on_focus_lost_hide': True,
}

groups.append(ScratchPad('scratchpad', [
    DropDown('term', 'alacritty --class=scratch', **conf),
    DropDown('btop', 'alacritty --class=btop -e btop', **conf),
    # DropDown('clip', 'alacritty --class=clipboard -e clipse', **conf),
    DropDown('spotify', 'spotify', **conf),
    DropDown('pavucontrol', 'pavucontrol', **conf),
]))

keys.extend([
    Key([win], 'n', lazy.group['scratchpad'].dropdown_toggle('term')),
    Key([win], 'b', lazy.group['scratchpad'].dropdown_toggle('btop')),
    # Key([win], 'v', lazy.group['scratchpad'].dropdown_toggle('clip')),
    Key([win], 's', lazy.group['scratchpad'].dropdown_toggle('spotify')),
    Key([win], 'p', lazy.group['scratchpad'].dropdown_toggle('pavucontrol')),
])

dgroups_key_binder = simple_key_binder("mod4")
dgroups_app_rules = [
]
