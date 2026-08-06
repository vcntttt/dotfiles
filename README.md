# Dotfiles

Configuración compartida para CachyOS/Hyprland/Noctalia en el desktop y el
notebook, más una capa de shell para el servidor Ubuntu de Caburgua.

## Instalación

Instala `git` y `stow`, clona el repositorio y ejecuta el script del equipo:

```bash
cd ~/dotfiles
bash shell/setup-notebook.sh
```

Scripts disponibles:

```bash
bash shell/setup-desktop.sh
bash shell/setup-notebook.sh
bash shell/setup-caburgua.sh
```

Los scripts escriben el host local en `~/.config/dotfiles/host`, respaldan los
archivos reales que serán reemplazados en
`~/.local/state/dotfiles/backups/` y aplican los paquetes Stow correspondientes.
No usan `--adopt` ni borran el estado runtime de Noctalia.

Perfiles aplicados:

```text
desktop   shell-common + common + graphical + desktop
notebook  shell-common + common + graphical + notebook
caburgua  shell-common + caburgua
```

La configuración común y los overrides host-specific quedan enlazados
directamente al repositorio. Editar un archivo de `desktop/`, `notebook/` o
`caburgua/` no requiere otro comando de aplicación; solo hay que recargar la
aplicación correspondiente cuando el cambio deba verse inmediatamente.

## Organización

- `shell-common/`: Fish, tmux y utilidades CLI compartidas.
- `common/`: configuraciones compartidas entre los equipos de escritorio.
- `graphical/`: base común de Hyprland, Noctalia, Ghostty y aplicaciones GUI.
- `desktop/`: dos monitores, autostart y estado de Noctalia del desktop.
- `notebook/`: `eDP-1`, touchpad, mirror/extend y estado de Noctalia del notebook.
- `caburgua/`: aliases y ajustes de Fish para Ubuntu Server.

## Validación

```bash
stow --no --verbose=1 --dir=. --target="$HOME" --no-folding \
  shell-common common graphical notebook
fish -n ~/.config/fish/config.fish
noctalia config validate
hyprctl configerrors
```

El estado generado, caches, catálogos, credenciales y temas de Noctalia
permanecen fuera del repositorio.
