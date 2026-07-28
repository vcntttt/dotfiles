# Adopción de CachyOS, Noctalia y Fish

## Contexto

La rama `main` todavía representaba el stack anterior de Hyprland con Waybar,
Rofi y SwayNC. El sistema actual usa CachyOS, Hyprland Lua, Noctalia y Fish. La
rama `arch-hyprland-vanilla` conserva la implementación anterior.

## Decisión

La rama `main` pasa a representar solamente el desktop actual, sin variantes
por host.

Se adoptan desde el sistema los archivos declarativos de Hyprland, Noctalia,
Fish, UWSM y las aplicaciones tematizadas. También se versiona
`.local/state/noctalia/settings.toml` para que los cambios hechos desde la GUI
queden registrados en el working tree.

Los demás archivos de `.local/state/noctalia`, las credenciales y los temas
generados se mantienen fuera de Git.

## Stow

El repositorio incluye `.stowrc` con `--no-folding`. Stow crea directorios
reales y enlaza archivos individuales, evitando que Noctalia escriba estado o
archivos generados dentro del repositorio por accidente.

Antes de enlazar se respalda y retira únicamente cada archivo runtime adoptado.
La operación se valida primero mediante dry-run y después con las herramientas
de Fish, Noctalia e Hyprland.

## Alcance eliminado

- configuración Hyprland en formato `.conf`;
- Waybar, Rofi, SwayNC y Wofi;
- Hyprpaper, Hyprlock y helpers asociados;
- configuración Zsh y plugins;
- generación de overrides por host.

## Criterios de éxito

- `stow .` termina sin conflictos;
- los archivos administrados son symlinks al repo;
- la GUI de Noctalia escribe en el `settings.toml` versionado;
- `noctalia config validate` y `hyprctl configerrors` no informan errores;
- Fish puede analizar su configuración;
- los temas y el estado runtime de Noctalia permanecen fuera del repo.
