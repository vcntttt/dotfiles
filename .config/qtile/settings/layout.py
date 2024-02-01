from libqtile import layout
from libqtile.config import Match
from .theme import colors, statsFont

bordersConfig = {
    'margin': 5,
    'border_focus': colors['border_focus'],
    'border_normal': colors['border_normal'],
}

layouts = [
    layout.Max(),
    layout.Columns(**bordersConfig),
    layout.MonadTall(**bordersConfig, ratio=0.68),
    # layout.MonadThreeCol(**bordersConfig),
]

floating_layout = layout.Floating(
    border_width=1,
    border_focus=colors['border_focus'],
    border_normal=colors['border_normal'],
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
