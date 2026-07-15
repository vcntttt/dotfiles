# Modo rebase

## Evaluación previa

Comprueba rama actual, estado limpio, upstream, merge-base, commits locales y si la rama ya fue publicada. En `main`/`master`, aborta cualquier rebase destructivo. Si hay commits publicados, advierte que podría requerirse `--force-with-lease` y pide confirmación.

## Estrategias

- `squash` o limpieza: rebase interactivo/autosquash según la intención.
- `fixup!`/`squash!`: `GIT_SEQUENCE_EDITOR=: git rebase -i --autosquash <base>`.
- Actualizar desde main: `git fetch origin` y `git rebase origin/main`, con autorización.
- Reordenar o dividir: pausa, muestra el plan y conserva los cambios verificables.

## Conflictos y verificación

1. Inspecciona `git status` y los archivos en conflicto.
2. Comprende ambas versiones y elimina marcadores de conflicto.
3. Haz stage solo de lo resuelto y continúa.
4. Si la resolución es incierta, usa `git rebase --abort`.
5. Verifica `git status`, historial resultante y validaciones del proyecto.

Usa siempre `--force-with-lease`, nunca `--force`, cuando el push posterior haya sido aprobado explícitamente.
