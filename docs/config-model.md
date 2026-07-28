# Modelo de configuración

## Objetivo

`~/dotfiles` es la fuente de verdad del desktop principal. La rama `main`
representa CachyOS con Hyprland Lua, Noctalia y Fish.

Por ahora no existen overrides por host. El notebook conserva el setup anterior
en la rama `arch-hyprland-vanilla`.

## Stow

Los archivos runtime deben ser symlinks hacia este repositorio. `.stowrc`
establece `--no-folding` para impedir que un directorio completo como
`~/.local/state/noctalia` apunte al repo.

Esto permite mezclar:

- archivos declarativos enlazados al repo;
- temas generados por Noctalia;
- estado runtime y cachés locales.

## Noctalia

Noctalia carga su configuración en este orden:

1. defaults internos;
2. archivos TOML de `.config/noctalia/`;
3. `.local/state/noctalia/settings.toml`.

La última capa contiene los cambios de la GUI y gana cuando una clave también
está presente en la configuración declarativa.

Para modificar desde código una opción administrada por la GUI, se edita
directamente el `settings.toml` versionado. `config.toml` queda para valores
declarativos que no compiten con esa capa.

Se versiona:

- `.config/noctalia/`;
- `.local/state/noctalia/settings.toml`.

No se versiona:

- `state.toml`;
- historiales y contadores de uso;
- cachés y catálogos descargados;
- credenciales;
- temas `noctalia.*` generados para otras aplicaciones.

## Hyprland

Hyprland usa Lua desde `.config/hypr/hyprland.lua`. Los módulos viven en
`.config/hypr/config/` y se cargan mediante `require`.

La configuración antigua en formato Hyprlang, junto con Waybar, Rofi, SwayNC,
SwayOSD, Hyprpaper e Hyprlock, permanece únicamente en la rama legacy.

## Validación

```bash
stow --no --verbose=1 .
fish -n ~/.config/fish/config.fish
noctalia config validate
hyprctl configerrors
```
