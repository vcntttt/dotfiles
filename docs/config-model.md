# Modelo de Configuracion por Host

## Objetivo

Mantener una sola base comun en `~/dotfiles` y aplicar despues un override pequeno por dispositivo.

El orden mental siempre debe ser este:

1. Base comun versionada
2. Host activo seleccionado localmente
3. Override por host cargado despues de la base

## Fuente de verdad

- La base comun vive en archivos versionados dentro de `~/dotfiles`.
- Los overrides por host tambien viven versionados en `~/dotfiles`.
- El unico dato local no versionado es el host activo en `.config/dotfiles/host`.

Hosts validos actuales:

- `desktop`
- `notebook`
- `homelab`

## Seleccion del host

El archivo `.config/dotfiles/host` contiene un solo valor con el nombre del host activo.

Ese valor es cargado por `shell/host.sh`, que exporta `DOTFILES_HOST` para que el resto de la configuracion pueda usarlo.

## Aplicacion de overrides

El script `.local/bin/apply-host-config` genera archivos locales puente segun el host activo.

Archivos generados actuales:

- `.config/hypr/host.conf`
- `.config/rofi/host.rasi`
- `.config/waybar/host.css`
- `.config/waybar/config.jsonc`
- `.config/ghostty/host`

Estos archivos generados no son la fuente de verdad. Solo conectan la configuracion runtime con los archivos versionados en `hosts/`.

## Regla de carga

Cada aplicacion debe seguir el mismo patron:

1. Cargar base comun
2. Cargar override por host al final

Modelo actual:

- Hyprland: `.config/hypr/hyprland.conf` carga base y luego `host.conf`
- Rofi: `.config/rofi/launcher.rasi` carga base y luego `host.rasi`
- Waybar: `style.css` carga `base.css` y luego `host.css`; `config.jsonc` se genera desde `config.base.jsonc` y `hosts/<host>.jsonc`
- Ghostty: `.config/ghostty/config` carga base y luego `host`

## Que va en base

Poner en base todo lo que deberia ser igual en todos los equipos.

Ejemplos:

- tema general
- estructura de archivos
- aliases compartidos
- bindings comunes
- modulos comunes de Waybar
- defaults visuales

## Que va en host

Poner en host todo lo que depende del hardware, uso del equipo o contexto.

Ejemplos:

- monitores
- layout de teclado
- escala
- font-size especifico
- autostart distinto entre desktop y notebook
- ajustes solo validos en GUI o en servidor

## Regla practica

Si al cambiar de equipo el valor deberia seguir siendo el mismo, va en base.

Si depende del dispositivo donde corre, va en host.

## Mantenimiento

Cuando se agregue una nueva app con configuracion por dispositivo:

1. Crear base comun versionada
2. Crear overrides versionados por host
3. Hacer que runtime cargue siempre `base -> host`
4. Evitar configuraciones locales manuales fuera de ese patron

## Verificacion manual

- Confirmar host activo en `.config/dotfiles/host`
- Regenerar archivos puente con `bash ~/.local/bin/apply-host-config`
- Si se cambia Hyprland: `hyprctl reload`
- Si se cambia Waybar: recargar Waybar manualmente
- Si se cambia una app nueva: validar que el archivo final cargue primero base y despues host
