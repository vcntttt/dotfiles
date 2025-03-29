from libqtile import layout

class Android(layout.MonadTall):
    defaults = [
        ("ratio", 0.75, "Initial ratio of the main pane"),
    ]

    def __init__(self, **config):
        config.setdefault("ratio", 0.75)  # Define tu ratio por defecto aquí
        super().__init__(**config)