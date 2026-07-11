# Modo commit

## Preparación

Inspecciona en paralelo:

```bash
git status --porcelain=v1 -uall
git diff
git diff --cached
git log -30 --oneline
git branch --show-current
git rev-parse --abbrev-ref @{upstream} 2>/dev/null || echo NO_UPSTREAM
git merge-base HEAD main 2>/dev/null || git merge-base HEAD master
```

Detecta idioma y estilo de los commits recientes. Usa Conventional Commits en español cuando el repositorio no indique otra convención.

## Plan atómico

- Entiende y clasifica todo cambio del working tree antes de hacer staging.
- Agrupa por unidad lógica, directorio y dependencia; no mezcles concerns independientes.
- Mantén implementación y su test directo juntos.
- Para cada grupo con 3 o más archivos, explica por qué son inseparables.
- Ordena por dependencias: tipos/utilidades, modelos, lógica, endpoints, infraestructura.
- Presenta el plan completo y pide aprobación explícita antes de crear commits.

## Ejecución

Después de aprobar:

```bash
git add <archivos-del-grupo>
git diff --cached --stat
git diff --cached
git commit -m "tipo(scope): resumen en español"
git log -1 --oneline
```

Nunca uses `git add .` ni `git commit -a`. Valida según el proyecto antes de cada commit y verifica al final que solo quedó trabajo no aprobado.
