# Modelo de Sincronizacion

## Objetivo

Separar claramente que cosa es fuente de verdad y que cosa solo existe para sincronizar, navegar o enlazar.

El problema principal aparece cuando mas de una carpeta intenta ser la duena de la misma informacion.

## Ejes principales

Hay dos ejes distintos:

1. Configuracion del sistema Arch y aplicaciones
2. Material de universidad, apuntes, archivos y proyectos

No deben mezclarse.

## Fuente de verdad por tipo de contenido

### Configuracion

- `~/dotfiles` es la fuente de verdad
- Los runtime paths como `~/.config/...`, `~/.local/bin/...` o `~/.zshrc` deben apuntar al repo o derivarse de el

### Codigo y proyectos

- `~/dev` debe ser la fuente de verdad para repos, proyectos y trabajo de desarrollo

### Apuntes

- `~/Notas` debe ser la fuente de verdad para notas y material de Obsidian

### Archivos sincronizados

- `~/Nextcloud` debe usarse para archivos que realmente quieres sincronizar entre equipos
- `~/Nextcloud` no deberia competir con `~/dev` ni `~/Notas` como fuente de verdad del mismo contenido

## Modelo mental recomendado

La recomendacion para universidad es esta:

- `~/dev` para codigo
- `~/Notas` para apuntes
- `~/Nextcloud` para PDFs, guias, entregables, material descargado y, si quieres, accesos directos hacia trabajo o notas

En este modelo, `Nextcloud` es un hub de sincronizacion y navegacion, no la raiz maestra de todo.

## Relacion entre carpetas

### `~/dotfiles`

- Config del sistema
- Scripts utilitarios
- Config por host

### `~/dev`

- Repos git
- Proyectos de ramos
- Trabajo activo

### `~/Notas`

- Vault principal
- Estructura de conocimiento personal
- Notas de universidad en `200 - UCT`

### `~/Nextcloud`

- Material sincronizado entre equipos
- Documentos generales como `Documents/` y `Pictures/`
- Material academico en `Nextcloud/informatica/`

## Regla de ownership

Cada tipo de contenido debe tener un solo owner:

- config -> `dotfiles`
- codigo -> `dev`
- notas -> `Notas`
- archivos sincronizados -> `Nextcloud`

Los symlinks pueden ayudar a navegar, pero no deben ocultar quien manda.

## Uso de symlinks

Los symlinks son utiles cuando exponen una vista conveniente del sistema.

Buenos usos:

- `Documents -> Nextcloud/Documents`
- `Pictures -> Nextcloud/Pictures`
- un link desde `Nextcloud/informatica/...` hacia un repo real en `~/dev`
- un link desde un ramo hacia su carpeta de notas real en `~/Notas`

Malos usos:

- usar symlinks en ambos sentidos hasta perder la fuente de verdad
- construir `dev` desde `Nextcloud` y luego volver a linkear `Nextcloud` hacia `dev`
- mezclar carpetas reales y symlinks para la misma funcion sin una regla clara

## Regla practica para universidad

Si vas a editar codigo, la carpeta real debe vivir en `~/dev`.

Si vas a escribir apuntes, la carpeta real debe vivir en `~/Notas`.

Si vas a guardar o sincronizar material descargado, la carpeta real debe vivir en `~/Nextcloud`.

Si necesitas verlo desde otro lado, usa un link, pero solo desde la vista secundaria hacia la ruta real.

## Scripts actuales

Scripts relacionados hoy:

- `.local/bin/dirs.py`: herramienta principal para crear o normalizar la estructura de ramos entre `Nextcloud`, `Notas` y `dev`. Crea la vista del ramo en `Nextcloud` y enlaza `Notas` y `work` hacia sus owners reales.
- `.local/bin/setup-semestre`: bootstrap de un semestre ya existente en `Nextcloud` hacia `~/dev/<semestre>`. Puede crear carpetas base de ramos y, con `--link-existing`, pedir enlaces para repos git ya presentes.
- `.local/bin/symbolycs`: helper puntual para crear un symlink desde `Nextcloud/informatica/<semestre>/<ramo>/<repo>` hacia el repo real en `~/dev/<semestre>/<ramo>/<repo>`.
- `~/Nextcloud/setup-nextcloud-assets.sh`: bootstrap de assets sincronizados del sistema en una maquina nueva. Solo enlaza rutas globales como `Documents`, `Pictures`, `icons` y `themes` hacia `Nextcloud`.

Separacion actual de responsabilidades:

- `dirs.py`, `setup-semestre` y `symbolycs` pertenecen al modelo academico.
- `setup-nextcloud-assets.sh` pertenece al setup global de assets sincronizados.

Estos scripts deben evaluarse con una regla simple: cualquier automatizacion nueva debe reforzar el ownership unico de cada carpeta, no mezclarlo.

## Direccion futura

Antes de simplificar scripts, mantener este criterio:

1. Declarar una sola fuente de verdad por tipo de dato
2. Usar symlinks solo como vistas secundarias
3. Evitar sincronizaciones bidireccionales implícitas
4. Preferir menos scripts, con responsabilidades mas claras

## Semestre activo portable

Para el semestre activo, existe una capa adicional de portabilidad:

- `~/Nextcloud/informatica/7mo-Semestre/.semester-state.json`

Ese archivo guarda el estado deseado del semestre, no el estado observado de una maquina puntual.

Su objetivo es permitir que otra maquina, como el notebook, pueda reconstruir la misma estructura del semestre a partir de una fuente sincronizada.

### Que define `.semester-state.json`

- semestre activo
- slugs de ramos
- nombre visible de notas por ramo
- repos git esperados por ramo
- remote y branch esperados para cada repo declarado

### Que no define

- contenido detallado de archivos del ramo
- snapshot del contenido de `Nextcloud`, `Notas` o `dev`
- estado temporal de una maquina especifica

### Flujo recomendado

1. Mantener `Nextcloud` como hub del ramo.
2. Mantener `Notas` como fuente real de apuntes.
3. Mantener `dev` como fuente real de repos y proyectos.
4. Actualizar `.semester-state.json` cuando cambie la estructura deseada del semestre.

### Comandos OpenCode asociados

Dentro de este repo existen dos comandos para trabajar con la metadata del semestre:

- `/semestre-capturar`
- `/semestre-aplicar`

#### `/semestre-capturar`

- corre en modo `plan`
- inspecciona el semestre actual
- propone el JSON deseado
- no escribe archivos ni hace cambios

#### `/semestre-aplicar`

- corre en modo `build`
- lee `.semester-state.json`
- primero muestra un plan de cambios
- exige confirmacion explicita antes de ejecutar
- puede normalizar estructura y clonar repos faltantes

### Regla de seguridad

La metadata portable describe como deberia quedar el semestre.

El estado real de cada maquina debe inspeccionarse al momento de aplicar, no persistirse en el JSON.
