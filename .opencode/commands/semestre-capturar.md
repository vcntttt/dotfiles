---
description: Proponer metadata deseada del semestre actual
agent: plan
---

Inspecciona el estado actual de un semestre universitario y propone el contenido deseado para `.semester-state.json` sin escribir archivos.

Objetivo:
- Leer la estructura actual del semestre en `~/Nextcloud/informatica/<semestre>`.
- Detectar el nombre visible de notas desde el symlink `Notas` de cada ramo.
- Detectar repos git reales dentro de `~/dev/<semestre>/<ramo>`.
- Proponer un JSON deseado portable para replicar el semestre en otra maquina.

Reglas obligatorias:
- Responder siempre en espanol.
- Operar solo en modo lectura.
- No escribir ni modificar ningun archivo.
- No crear, borrar, mover ni clonar nada.
- Si el semestre no se especifica en la conversacion, asumir `7mo-Semestre`.
- Usar como metadata objetivo: `~/Nextcloud/informatica/<semestre>/.semester-state.json`.

Que debe inspeccionar:
- `~/Nextcloud/informatica/<semestre>`
- `~/Notas/200 - UCT/<semestre-notas>`
- `~/dev/<semestre>`
- Repos git dentro de cada ramo de `~/dev/<semestre>/<slug>`

Que debe extraer:
- `semester.id` si se puede inferir del nombre; si no, mantener el slug y dejar nota.
- `semester.files_slug`
- `semester.notes_name`
- `courses[].slug`
- `courses[].notes_name`
- `courses[].repos[]` con:
  - `name`
  - `remote`
  - `branch`

Formato de salida esperado:
1. Resumen corto del semestre inspeccionado.
2. Hallazgos relevantes o inconsistencias.
3. Bloque JSON propuesto listo para guardar en `.semester-state.json`.

Si existe ya un `.semester-state.json`, comparar lo observado contra ese archivo y mostrar el diff conceptual, a la espera de confirmación para actualizar el archivo.
