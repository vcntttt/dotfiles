# Modelo de configuración

## Objetivo

`~/dotfiles` es la fuente de verdad para tres entornos:

- desktop: CachyOS, Hyprland, Noctalia y dos pantallas;
- notebook: CachyOS, Hyprland, Noctalia, una pantalla interna y mirror;
- caburgua: Ubuntu Server y solo configuración de shell.

Desktop y notebook comparten la mayor parte de la configuración. Las
diferencias se mantienen como overlays pequeños, enlazados directamente por
Stow.

## Paquetes Stow

Los paquetes son:

- `shell-common`: Fish, tmux y utilidades de shell compartidas;
- `common`: configuraciones CLI compartidas por las máquinas de trabajo;
- `graphical`: base común de Hyprland, Noctalia, Ghostty y GUI;
- `desktop`, `notebook`: overrides del entorno gráfico;
- `caburgua`: override de shell para Ubuntu Server.

Los scripts aplican estos conjuntos:

```text
desktop   shell-common common graphical desktop
notebook  shell-common common graphical notebook
caburgua  shell-common caburgua
```

`.stowrc` activa `--no-folding` para enlazar archivos individuales y permitir
que existan directorios runtime junto a archivos administrados.

## Selección del host

Cada máquina conserva un archivo local no versionado:

```text
~/.config/dotfiles/host
```

Los scripts `shell/setup-desktop.sh`, `shell/setup-notebook.sh` y
`shell/setup-caburgua.sh` lo escriben y aplican los paquetes necesarios. El
archivo seleccionado del host queda como symlink directo al paquete elegido;
por eso editar un override no requiere regenerar un bridge.

## Hyprland

`graphical/.config/hypr/` contiene los módulos comunes. El archivo
`config/host.lua` pertenece al paquete seleccionado y define monitores,
teclado, touchpad, workspaces y autostart. `hyprland.lua` carga ese módulo
antes del resto de la configuración.

## Noctalia

Los plugins viven en `graphical/.config/noctalia/plugins/`. Como el formato de
configuración de Noctalia no ofrece overlays TOML equivalentes a los módulos de
Lua, `desktop/` y `notebook/` mantienen su propio `config.toml` y
`settings.toml`; el resto de la integración sigue siendo común.

El resto de `.local/state/noctalia/`, caches, catálogos, credenciales,
historiales y temas generados permanecen locales. Los scripts de setup solo
respaldan los archivos versionados que reemplazan.

## Caburgua

Caburgua no recibe los paquetes `common` ni `graphical`. Solo instala
`shell-common` y su overlay de Fish, evitando cargar configuración de CachyOS,
Hyprland, Noctalia o aliases gráficos.

## Validación

```bash
stow --no --verbose=1 --dir=. --target="$HOME" --no-folding \
  shell-common common graphical notebook
fish -n ~/.config/fish/config.fish
noctalia config validate
hyprctl configerrors
```
