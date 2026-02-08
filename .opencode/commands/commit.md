---
description: Crear commits git atomicos y seguros
agent: build
---

Crea uno o mas commits atomicos desde el working tree actual.

Principios:
- Usar la skill `git-master` para cualquier operacion de Git (status, diff, add, commit, log).
- Responder siempre en español.
- Mensajes de commit siempre en español.
- No commitear secretos/credenciales (por ejemplo `.env`, `.env.local`, `credentials.json`).
- No commitear exports grandes (por ejemplo `data/*.csv`) salvo pedido explicito.
- No hacer `git commit --amend`.
- No hacer `push`.

Flujo base:
- Ejecutar: `git status --porcelain=v1 -uall`, `git diff`, `git log -10 --oneline --decorate`.
- Agrupar cambios en unidades atomicas logicas y buildables (schema, UI, docs, tests, etc.).
- No inferir estilo a partir de commits anteriores.
- Hacer staging y commit por grupo con mensajes semanticos (Conventional Commits) en español.
- Formato sugerido: `tipo(scope): resumen en español` (ej. `feat(auth): agrega login con SSO`).
- Incluir una breve razon en el cuerpo del commit (1-2 lineas explicando el por que).

Integracion Linear (solo si aplica):
- Detectar si el `AGENTS.md` del repo actual menciona Linear (por ejemplo "Linear workflow").
- Si aplica, hacer lo mismo que el flujo de Linear actual:
  - Detectar IDs de issues mencionados en la sesion o el trabajo.
  - Marcar issues activas como `In Progress` antes de finalizar commits (asignar a `me` si aplica).
  - Luego de commitear, listar issues que se completarian y pedir confirmacion antes de cerrarlas.
  - Si se confirma, comentar con hashes de commit + resultados de verificacion y mover a Done.
  - Si no hay issues, pedir IDs y no cerrar nada.

Verificacion automatica (si aplica):
- Buscar `package.json` en el repo actual.
- Si existen scripts `check` y/o `test`, ejecutar con Bun:
  - `bun run check` si existe.
  - `bun run test` si existe.
- Si no existen esos scripts, omitir verificacion.

Si el agrupamiento es ambiguo, hacer una sola pregunta dirigida con una recomendacion por defecto.
