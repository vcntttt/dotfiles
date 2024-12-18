from libqtile.config import Screen
from .widgets import statusBar

# Configuración de las pantallas
screens = [
    Screen(top=statusBar(True)),
    Screen(top=statusBar()),
]
