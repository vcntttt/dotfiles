---
name: git-master
description: "Git guardrails and routing for commits, rebases, history searches, and conflict recovery. Use when performing any Git operation or when another Git skill requests it."
---

# Git Master

Esta skill es el punto común para operaciones Git. Primero identifica el modo y lee únicamente la referencia correspondiente:

- **Commit**: [references/commit.md](references/commit.md)
- **Rebase, squash o limpieza de historia**: [references/rebase.md](references/rebase.md)
- **Blame, bisect o búsqueda histórica**: [references/history-search.md](references/history-search.md)

## Guardrails compartidos

- Responde en español y trabaja con el estado real del repositorio.
- Antes de modificar historia, inspecciona rama, upstream, merge-base, estado y commits locales.
- Nunca hagas `push`, `--amend`, `reset --hard` ni reescritura de historia sin autorización explícita.
- En ramas principales nunca hagas rebase destructivo.
- Preserva cambios existentes; separa cambios del usuario de los propios.
- No incluyas secretos, `.env`, credenciales ni archivos generados sin autorización.
- Después de cualquier operación, verifica `git status` y resume exactamente qué cambió.

## Selección de modo

| Petición | Referencia |
|---|---|
| crear commits, agrupar cambios, mensaje de commit | `commit.md` |
| rebase, squash, autosquash, reordenar o dividir commits | `rebase.md` |
| cuándo se añadió, quién cambió, blame, bisect, historial | `history-search.md` |

No cargues las otras referencias salvo que la tarea cambie de modo.
