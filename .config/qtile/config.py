# Vicente Rivera - 2023
import subprocess, time
from os import path
from libqtile import hook, qtile, layout

# myconfig
from settings.keys import keys
from settings.groups import groups,dgroups_app_rules,dgroups_key_binder
from settings.layout import layouts,floating_layout
from settings.widgets import widget_defaults,extension_defaults
from settings.screens import screens
from settings.mouse import mouse
main = None

follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True
wl_input_rules = None
wmname = "qtile"

keys = list(set(keys))

#@hook.subscribe.client_managed
#@hook.subscribe.client_killed
# def set_gaps(window=None):
#    gap_size = 8  
#    for group in qtile.groups:
#        if isinstance(group.layout, layout.Max):
#            group.layout.margin = 0
#        else:
#            group.layout.margin = gap_size if len(group.windows) > 1 else 0
#
#    qtile.current_group.layout_all()
def delayed_setup():
    time.sleep(2)  # Ajusta el tiempo de espera según sea necesario
    qtile.reconfigure_screens()

# Agrega la tarea de retardo al inicio de Qtile
@hook.subscribe.startup_complete
def startup():
    delayed_setup()

@hook.subscribe.startup_once
def startOnce():
    home = path.expanduser('~')
    subprocess.call([home + '/.config/qtile/autostart.sh'])
