---
name: semestre-aplicar
description: Aplicar con confirmación explícita la metadata deseada de un semestre universitario.
disable-model-invocation: true
---

# Aplicar semestre

Aplica la metadata deseada de un semestre universitario para alinear la máquina
actual con `.semester-state.json`.

## Reglas obligatorias

- Responde siempre en español.
- Si no se especifica el semestre, usa `7mo-Semestre`.
- Antes de cambiar nada, muestra un bloque `Plan de cambios`.
- Pide confirmación explícita antes de ejecutar cualquier cambio.
- Si el usuario no confirma claramente, detente sin modificar nada.
- No hagas `git pull`, `git reset`, `git clean`, `git checkout --` ni operaciones
destructivas en repositorios existentes.
- Si un repositorio existe y su remote o branch no coincide, repórtalo y no lo
corrijas automáticamente.
- Si una ruta existente bloquea un symlink esperado, repórtalo y no la borres.
- No actualices automáticamente `.semester-state.json`.

## Metadata de entrada

Lee:

```text
~/Nextcloud/informatica/<semestre>/.semester-state.json
```

Si no existe, detente e indica que primero debe ejecutarse `semestre-capturar` o
crearse el archivo manualmente.

## Cambios permitidos después de confirmar

- Ejecutar `python3 ~/.local/bin/dirs.py normalizar <semestre>`.
- Crear carpetas faltantes en `~/dev/<semestre>/<ramo>`.
- Crear symlinks faltantes `Notas` y `work` dentro de cada ramo del hub en
  Nextcloud.
- Clonar repositorios faltantes declarados en `courses[].repos[]` dentro de
  `~/dev/<semestre>/<ramo>/<repo>`.

No borres archivos o carpetas reales sin una segunda confirmación específica.

## Flujo

1. Lee `.semester-state.json`.
2. Inspecciona el estado actual.
3. Clasifica:
   - estructura correcta
   - symlinks faltantes
   - carpetas faltantes
   - repositorios faltantes por clonar
   - conflictos detectados
4. Muestra el bloque `Plan de cambios`.
5. Pide confirmación explícita.
6. Solo después de confirmar, aplica los cambios permitidos.
7. Muestra un resumen de lo realizado y lo pendiente.

**Criterio de finalización:** no se ejecuta ningún cambio sin confirmación, cada
acción aplicada queda reportada y todos los conflictos quedan explícitamente
pendientes o resueltos de forma segura.
