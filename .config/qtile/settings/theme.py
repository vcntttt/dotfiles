

colors = {
    "background": "#0E1415",
    "primary": "#88DB3F",
    "secondary": "4AC9E2",
    "alert": "#F36868",
    "border_focus": "#7f849c",
    "border_normal": "#313244",
    "dark": "#0E1415",
    "foreground": "#fafafa",
    "blue" : "#0075ea",
    "red": "#ff3029",
    "inactiveGroup": "#ccc",
    "spotify": "#1ED760",
}

barFont = "UbuntuMono Nerd Font"

DoomOne = [
    ["#282c34", "#282c34"], # bg
    ["#bbc2cf", "#bbc2cf"], # fg
    ["#1c1f24", "#1c1f24"], # color01
    ["#ff6c6b", "#ff6c6b"], # color02
    ["#98be65", "#98be65"], # color03
    ["#da8548", "#da8548"], # color04
    ["#51afef", "#51afef"], # color05
    ["#c678dd", "#c678dd"], # color06
    ["#46d9ff", "#46d9ff"]  # color15
    ]



# from qtile_extras.widget.decorations import PowerLineDecoration
# from libqtile import bar, widget, qtile
# from .keys import terminal
# from .theme import colors, barFont
# from customWidgets.spotify import Spotify

# # Widgets
# widget_defaults = dict(
#     font=barFont,
#     fontsize=12,
#     padding=3,
# )
# extension_defaults = widget_defaults.copy()


# decor_groups = {
#     'decorations': [
#         PowerLineDecoration(
#             path='arrow_left',
#             # path='rounded_left'
#             # path='forward_slash'
#             # path='back_slash'
#         )
#     ]
# }

# decor_right = {
#     'background': colors['blue'],
#     'foreground': colors['foreground'],
#     'decorations': [
#         PowerLineDecoration(
#             path='arrow_right',
#             # path='rounded_right'
#             # path='forward_slash'
#             # path='back_slash'
#         )
#     ],
# }


# def my_bar():
#     return bar.Bar(
#         [   widget.Spacer(
#                 length=5,
#             ),
#             widget.Image(
#                 filename='~/pictures/archlinux-svgrepo-com.svg',
#                 scale='False',
#                 margin=4,
#             ),
#             widget.Spacer(
#                 length=5,
#             ),
#             widget.GroupBox(
#                 **decor_groups,
#                 background= colors['foreground'],
#                 highlight_method='line',
#                 highlight_color= colors['foreground'],
#                 foreground='#000000',
#                 other_screen_border=colors['red'],
#                 other_current_screen_border=colors['red'],
#                 rounded=True,
#                 this_current_screen_border=colors['blue'],
#                 inactive=colors['inactiveGroup'],
#                 active='#000',
#                 fontsize=20,
#                 padding=5
#         ),
#             widget.WindowName(
#                 font='UbuntuMono Nerd Font',
#                 fontsize=14,
#                 max_chars=50,
#                 width=400,
#                 padding=10
#         ),
#             widget.Spacer(),
#             Spotify(
#                 font='UbuntuMono Nerd Font',
#                 fontsize=14,
#                 padding=10,
#         ),
#             widget.CurrentLayout(
#                 foreground = colors['foreground'],
#                 background = colors['dark'],
#                 font='UbuntuMono Nerd Font',
#                 fontsize=14,
#                 padding=8
#         ),
#             widget.Spacer(
#                 **decor_right,
#                 length=10
#         ),
#             # widget.Systray(),
#             widget.CPU(
#                 **decor_right,
#                 format='▓  CPU: {load_percent}%',
#                 mouse_callbacks={
#                     'Button1': lambda: qtile.cmd_spawn(terminal + ' -e btop')
#                 }
#         ),
#             widget.Memory(
#                 **decor_right,
#                 format='🖥  Mem: {MemUsed: .0f}{mm}',
#                 mouse_callbacks={
#                     'Button1': lambda: qtile.cmd_spawn(terminal + ' -e btop')
#                 }
#         ),
#             widget.Volume(
#                 **decor_right,
#                 padding=10,
#                 fmt='Vol: {}',
#                 mouse_callbacks={
#                     'Button1': lambda: qtile.cmd_spawn('pavucontrol')
#                 }
#         ),
#             widget.DF(
#                 **decor_right,
#                 padding=10,
#                 visible_on_warn=False,
#                 format='Disk: {p} {uf}{m} ({r:.0f}%)',
#         ),
#             widget.Battery(
#                 **decor_right,
#                 format='{char} {percent:2.0%}',
#                 update_interval=10,
#                 discharge_char='',
#                 full_char='',
#                 charge_char='',
#                 empty_char='',
#         ),
#             widget.Clock(
#                 **decor_right,
#                 padding=10,
#                 format='⏱  %a, %d %b -- %H:%M',
#         ),
#             widget.TextBox(
#                 **decor_right,
#                 text='',
#                 fontsize=16,
#                 mouse_callbacks={'Button1': lambda: qtile.cmd_spawn(
#                     '/home/vrivera/.local/bin/powermenu')}
#         ),
#             widget.Spacer(
#                 **decor_right,
#                 length=10
#         ),
#         ],
#         30,
#         background=colors['background']
#     )
