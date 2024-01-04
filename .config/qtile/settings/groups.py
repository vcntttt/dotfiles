from libqtile.config import Group, Key, ScratchPad, DropDown, Match, Rule
from libqtile.command import lazy
from .keys import keys, win
from libqtile.dgroups import simple_key_binder
from .theme import colors
groups = []

groupsNames = ['1', '2', '3', '4', '5', '6', '7', '8', '9']

groupsLabels = ['', "\ue63c", '', '', '5', '6', '7', ' ', '']

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
}

groups.append(ScratchPad('scratchpad', [
    DropDown('term', 'alacritty --class=scratch', **conf),
    DropDown('btop', 'alacritty --class=btop -e btop', **conf),
    DropDown('ranger', 'alacritty --class=ranger -e ranger', **conf),
]))

keys.extend([
    Key([win, 'shift'], 'Return', lazy.group['scratchpad'].dropdown_toggle('term')),
    Key([win], 'b', lazy.group['scratchpad'].dropdown_toggle('btop')),
    Key([win], 'n', lazy.group['scratchpad'].dropdown_toggle('ranger')),
])

dgroups_key_binder = simple_key_binder("mod4")
dgroups_app_rules = [
    Rule(
        Match(wm_class=['spotify']), group='8',
    )
]
