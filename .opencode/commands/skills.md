---
description: Actualizar mapa de skills en AGENTS.md
agent: build
---

Actualiza el mapa de skills disponible en el `AGENTS.md` del repo actual.

Objetivo:
- Cada ejecucion debe escanear:
  - Skills globales disponibles (las built-in del runtime + las custom en `~/.opencode/skills`).
  - Skills del proyecto actual si existen en `./.opencode/skills`.
- Generar o actualizar la seccion "Skill map (OpenCode)" del `AGENTS.md` en la raiz del repo git.

Reglas:
- Solo buscar `AGENTS.md` en la raiz del repo git (no usar subcarpetas).
- Si no existe `AGENTS.md`, crear uno minimo en espanol con esa seccion.
- Si existe, reemplazar solo el contenido de la seccion "Skill map (OpenCode)" y preservar el resto del archivo.
- Responder en espanol.

Como construir el mapa:
- Identificar skills built-in disponibles en el runtime (nombre + descripcion).
- Leer skills custom en `~/.opencode/skills/*/SKILL.md`.
- Leer skills del proyecto en `./.opencode/skills/*/SKILL.md` si existen.
- Unificar y deduplicar por nombre.
- Orden sugerido: built-in, luego globales, luego proyecto.
- Para cada skill, incluir:
  - Nombre exacto del skill.
  - Descripcion breve.
  - Cuando usarlo (una frase simple).

Formato sugerido de la seccion:

## Skill map (OpenCode)

Use estas skills de forma intencional; cargalas cuando aplique.

- `nombre-skill`: descripcion corta. Cuando usarla: ...

Si no hay skills disponibles, dejar la seccion con una nota clara y breve.
