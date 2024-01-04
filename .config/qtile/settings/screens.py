from libqtile.config import Screen
from .widgets import my_bar
from qtile_extras.widget.decorations import PowerLineDecoration

# screens = [
#     Screen(
#         top=Bar(
#             [
#                 widget.CurrentLayoutIcon(background="000000", **powerline),
#                 widget.WindowName(background="222222", **powerline),
#                 widget.Clock(background="444444", **powerline),
#                 widget.QuickExit(background="666666")
#             ],
#             30
#         )
#     )
# ]
# Configuración de las pantallas
screens = [
    Screen(top=my_bar(True)),    
    Screen(top=my_bar()),
    Screen(top=my_bar()),
]
