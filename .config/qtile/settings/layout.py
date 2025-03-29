from libqtile import layout
from libqtile.config import Match
from .theme import colors
from .layouts.android import Android

bordersConfig = {
    "margin": 5,
    "border_focus": colors["border_focus"],
    "border_normal": colors["border_normal"],
}

layouts = [
    layout.Max(),
    layout.Columns(**bordersConfig),
    layout.MonadTall(**bordersConfig, ratio=0.68),
    Android(**bordersConfig),
    # layout.MonadThreeCol(**bordersConfig),
]

floating_layout = layout.Floating(
    border_width=2,
    border_focus=colors["border_focus"],
    border_normal=colors["border_normal"],
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="confirm"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(wm_class="pavucontrol"),
        Match(wm_class="dialog"),
        Match(wm_class="error"),
        Match(wm_class="file_progress"),
        Match(wm_class="notification"),
        Match(wm_class="splash"),
        Match(wm_class="toolbar"),
        Match(wm_class="download"),
        Match(wm_class="libre-menu-editor"),
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ],
)
