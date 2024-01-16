from libqtile import layout
from libqtile.config import Match
from .theme import colors

bordersConfig = {
    'margin': 0,
    'border_focus': colors['border_focus'],
    'border_normal': colors['border_normal'],
}

layouts = [
    layout.Columns(**bordersConfig),
    layout.Max(),
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadTall(**bordersConfig),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="conky"),  # gitk
    ],
)
