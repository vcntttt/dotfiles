from libqtile.config import Click, Drag
from libqtile.lazy import lazy

from .keys import win

# Drag floating layouts.
mouse = [
    Drag([win], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([win], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([win], "Button2", lazy.window.bring_to_front()),
]