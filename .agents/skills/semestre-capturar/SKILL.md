---
name: semestre-capturar
description: Inspeccionar un semestre universitario y proponer su metadata deseada sin modificar archivos.
disable-model-invocation: true
---

# Capturar semestre

Inspecciona el estado actual de un semestre universitario y propone el contenido
deseado para `.semester-state.json`. Esta skill es exclusivamente de lectura.

## Reglas

- Responde siempre en español.
- Si no se especifica el semestre, usa `7mo-Semestre`.
- No escribas ni modifiques archivos.
- No crees, borres, muevas ni clones nada.
- Usa como metadata objetivo:
  `~/Nextcloud/informatica/<semestre>/.semester-state.json`.

## Inspección

Revisa:

- `~/Nextcloud/informatica/<semestre>`
- `~/Notas/200 - UCT/<semestre-notas>`
- `~/dev/<semestre>`
- Repositorios Git reales dentro de `~/dev/<semestre>/<ramo>`.

Detecta:

- El nombre visible de notas desde el symlink `Notas` de cada ramo.
- Repositorios Git reales dentro de cada ramo.
- Remoto y branch de cada repositorio.
- Inconsistencias entre Nextcloud, Notas y `dev`.

## Metadata a proponer

- `semester.id`: inferido desde el nombre; si no es posible, usa el slug y deja una nota.
- `semester.files_slug`
- `semester.notes_name`
- `courses[].slug`
- `courses[].notes_name`
- `courses[].repos[]` con `name`, `remote` y `branch`.

## Salida

Entrega, en este orden:

1. Resumen breve del semestre inspeccionado.
2. Hallazgos relevantes e inconsistencias.
3. Bloque JSON propuesto, listo para guardar en `.semester-state.json`.

Si ya existe `.semester-state.json`, compáralo con lo observado y muestra el
diff conceptual. No actualices el archivo: solicita confirmación si el usuario
quiere aplicar esa actualización.

**Criterio de finalización:** se revisaron todas las rutas disponibles, se
reportaron inconsistencias y se entregó un JSON completo o se explicó por qué no
pudo construirse.
