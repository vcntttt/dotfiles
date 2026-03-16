---
description: Actualizar mapa de skills en AGENTS.md
agent: build
---

Actualiza el mapa de skills disponible en el `AGENTS.md` de la raiz del repo git actual.

Objetivo:
- En cada ejecucion, detectar y consolidar skills desde:
  1) Built-in del runtime (si estan disponibles en el contexto del agente).
  2) Skills globales en `~/.opencode/skills/*/SKILL.md` y `~/.agents/skills/*/SKILL.md`.
  3) Skills del proyecto en `./.opencode/skills/*/SKILL.md` y `./.agents/skills/*/SKILL.md`.
- Generar o actualizar la seccion `## Skill map (OpenCode)` en `AGENTS.md`.

Reglas obligatorias:
- Responder siempre en español.
- Solo operar sobre `AGENTS.md` en la raiz del repo git actual.
- Si no existe `AGENTS.md`, crearlo con contenido minimo y la seccion.
- Si existe, reemplazar solo el bloque de `## Skill map (OpenCode)` y preservar todo lo demas sin reordenar.
- No editar otras secciones.
- Mantener cambios minimos y deterministas (idempotente).

Deteccion del repo y archivo:
- Resolver raiz git con un metodo seguro.
- Objetivo final: `<git-root>/AGENTS.md`.
- Si no hay repo git, reportar error breve y salir sin cambios.

Como recolectar skills:
1) Built-in del runtime:
   - Obtener nombre + descripcion desde el listado de skills disponibles para el agente.
   - Si no se puede enumerar built-ins de forma confiable, continuar con globales/proyecto y dejar nota breve en la seccion.

2) Globales:
   - Leer `~/.opencode/skills/*/SKILL.md` y `~/.agents/skills/*/SKILL.md`.
   - Extraer:
     - nombre (preferir `# Skill: <nombre>`; fallback: nombre de carpeta)
     - descripcion (primer parrafo util del archivo)

3) Proyecto:
   - Leer `./.opencode/skills/*/SKILL.md` y `./.agents/skills/*/SKILL.md` si existen.
   - Extraer con la misma logica.

Normalizacion y deduplicacion:
- Deduplicar por nombre canonico (trim + lowercase).
- Preservar nombre original para mostrar.
- Prioridad de fuente al deduplicar:
  1) built-in
  2) global
  3) project
- Si una skill aparece en varias fuentes, conservar una sola entrada con la fuente de mayor prioridad.

Enriquecimiento de cada entrada:
- Para cada skill incluir:
  - Nombre exacto
  - Descripcion breve (1 frase)
  - Cuando usarla (1 frase simple y accionable)
  - Fuente: `built-in`, `global`, o `project`

Orden de salida:
- Primero `built-in`, luego `global`, luego `project`.
- Dentro de cada grupo, ordenar alfabeticamente por nombre visible.

Formato exacto de la seccion:
## Skill map (OpenCode)

Use estas skills de forma intencional; carguelas cuando aplique.

<!-- opencode-skill-map:start -->
- `nombre-skill`: descripcion breve. Cuando usarla: ... Fuente: built-in.
- `otro-skill`: descripcion breve. Cuando usarla: ... Fuente: global.
<!-- opencode-skill-map:end -->

Reglas de reemplazo de seccion:
- Si existe el bloque entre marcadores `<!-- opencode-skill-map:start -->` y `<!-- opencode-skill-map:end -->`, reemplazar solo su contenido interno.
- Si no existen marcadores pero existe el heading `## Skill map (OpenCode)`, reemplazar el contenido de esa seccion hasta el siguiente heading `## `.
- Si no existe la seccion, agregarla al final del archivo con el formato exacto.

Casos borde:
- Si no hay ninguna skill detectable, mantener la seccion con:
  - `No se detectaron skills disponibles en este entorno.`
- Si una skill no tiene descripcion clara, usar:
  - `Sin descripcion declarada en SKILL.md.`
- Si no se puede inferir “Cuando usarla”, usar:
  - `Cuando necesites este dominio especifico.`

Criterios de calidad:
- Salida estable entre ejecuciones (sin ruido de formato).
- No duplicados.
- No modificar contenido fuera de la seccion.
- Texto final en español.
