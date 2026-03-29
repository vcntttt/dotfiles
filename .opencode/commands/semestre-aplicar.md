---
description: Aplicar metadata deseada del semestre con confirmacion explicita
agent: build
---

Aplica la metadata deseada de un semestre universitario para dejar la maquina actual alineada con `.semester-state.json`.

Objetivo:
- Leer `~/Nextcloud/informatica/<semestre>/.semester-state.json`.
- Inspeccionar el estado actual en `Nextcloud`, `Notas` y `dev`.
- Mostrar primero un plan de cambios.
- Pedir confirmacion explicita.
- Solo despues de confirmar, ejecutar los cambios necesarios.

Reglas obligatorias:
- Responder siempre en espanol.
- Si el semestre no se especifica en la conversacion, asumir `7mo-Semestre`.
- Antes de cambiar nada, mostrar un bloque `Plan de cambios`.
- Antes de cambiar nada, pedir confirmacion explicita del usuario.
- Si el usuario no confirma claramente, detenerse sin hacer cambios.
- No hacer `git pull`, `git reset`, `git clean`, `git checkout --`, ni operaciones destructivas en repos existentes.
- Si un repo ya existe y su remote o branch no coincide, reportarlo y no corregirlo automaticamente.
- Si una ruta existente bloquea un symlink esperado, reportarlo y no borrarlo automaticamente.

Cambios permitidos despues de la confirmacion:
- Ejecutar `python3 ~/.local/bin/dirs.py normalizar <semestre>` para asegurar la topologia base.
- Crear carpetas faltantes en `~/dev/<semestre>/<ramo>` cuando correspondan.
- Crear symlinks faltantes `Notas` y `work` dentro de cada ramo del hub en `Nextcloud`.
- Clonar repos faltantes declarados en `courses[].repos[]` dentro de `~/dev/<semestre>/<ramo>/<repo>`.

Cambios no permitidos incluso con confirmacion:
- Borrar archivos o carpetas reales sin una segunda confirmacion especifica.
- Modificar repos git existentes para forzar coincidencia con el metadata.
- Actualizar automaticamente `.semester-state.json`.

Flujo exacto:
1. Leer `.semester-state.json`.
2. Inspeccionar estado actual.
3. Mostrar:
   - estructura correcta ya presente
   - symlinks faltantes
   - carpetas faltantes
   - repos faltantes por clonar
   - conflictos detectados
4. Pedir confirmacion explicita.
5. Solo si el usuario confirma, aplicar los cambios permitidos.
6. Mostrar resumen final de lo hecho y lo que quedo pendiente.

Si no existe `.semester-state.json`, detenerse y pedir al usuario que primero ejecute el flujo de captura o cree el archivo manualmente.
