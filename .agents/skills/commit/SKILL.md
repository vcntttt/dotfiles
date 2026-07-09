---
name: commit
description: Crear uno o más commits Git atómicos, seguros y con mensajes semánticos en español.
disable-model-invocation: true
---

# Commits atómicos

Esta skill se invoca explícitamente cuando el usuario quiere crear commits.
Al invocarla, inspecciona el working tree, diseña una agrupación completa de
commits atómicos y muestra el plan final para review mínima del usuario.

El usuario solo debe tener que aprobar o rechazar el plan. No le delegues el
diseño de la agrupación salvo que exista una ambigüedad real imposible de
resolver con la información disponible.

Después de recibir aprobación explícita, ejecuta el plan y crea los commits. No
hagas push, amend ni acciones destructivas.

## Flujo

### 1. Cargar Git Master

Antes de cualquier operación Git, carga y sigue la skill `git-master`.

### 2. Inspeccionar el working tree

Ejecuta:

```bash
git status --porcelain=v1 -uall
git diff
git diff --cached
git log -10 --oneline --decorate
```

Revisa todos los cambios, incluidos archivos no trackeados. Identifica secretos,
credenciales, exports grandes y archivos generados que no deban incluirse.

**Criterio de finalización:** cada cambio del working tree está entendido y
clasificado como parte de un commit, excluido explícitamente o pendiente de
aclaración.

### 3. Proponer grupos atómicos

Agrupa los cambios por unidad lógica y dependencias. No mezcles cambios que
puedan revertirse de forma independiente.

Usa mensajes Conventional Commits en español:

```text
tipo(scope): resumen breve en español
```

Incluye en el cuerpo una o dos líneas explicando el motivo del cambio.

Si el agrupamiento es ambiguo, resuelve con criterio propio cuando sea seguro.
Pregunta solo si hay una decisión que pueda cambiar materialmente la historia de
commits.

Presenta siempre un plan completo antes de hacer staging:

```text
Plan de commits
1. tipo(scope): resumen
   Archivos:
   - ruta/archivo
   Cuerpo: razón breve del cambio

2. tipo(scope): resumen
   Archivos:
   - ruta/archivo
   Cuerpo: razón breve del cambio
```

Cierra el plan preguntando por aprobación explícita, por ejemplo:

```text
¿Ejecuto este plan de commits? Responde "ok" para continuar.
```

**Criterio de finalización:** existe un plan completo con archivos por grupo,
orden de commits, mensaje y cuerpo para cada commit, y el usuario puede aprobarlo
sin tener que rediseñar la agrupación.

### 4. Revisar y commitear

Solo después de aprobación explícita del usuario, ejecuta el staging, las
validaciones y el commit.

Para cada grupo:

1. Haz staging únicamente de sus archivos.
2. Revisa `git diff --cached`.
3. Confirma que no contiene secrets, credenciales ni archivos excluidos.
4. Ejecuta las validaciones relevantes del proyecto.
5. Crea el commit.

No uses `git add .` ni `git commit -a`.

**Criterio de finalización:** el commit contiene exactamente el grupo aprobado,
la validación relevante pasó y el mensaje explica el cambio.

### 5. Verificación final

Después de todos los commits:

```bash
git status --short
git log -n <cantidad> --oneline --decorate
```

Comprueba que:

- Los commits son atómicos e independientes.
- No se hizo `push`.
- No se hizo `--amend`.
- No quedaron secretos staged o committed.
- El working tree solo contiene cambios que el usuario decidió conservar.

**Criterio de finalización:** todos los grupos planeados están commiteados y el
estado final fue reportado al usuario.

## Reglas permanentes

- Responde en español.
- Usa `git-master` para cualquier operación Git.
- Nunca hagas `git commit --amend`.
- Nunca hagas `git push`.
- No commitees `.env`, credenciales, tokens ni exports grandes salvo pedido
  explícito.
- Si no hay cambios commiteables, informa la razón en vez de crear un commit
  vacío.
