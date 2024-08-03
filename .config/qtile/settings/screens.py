from libqtile.config import Screen
from .widgets import my_bar

# Configuración de las pantallas
screens = [
    Screen(top=my_bar(True)),
    Screen(top=my_bar()),
]
