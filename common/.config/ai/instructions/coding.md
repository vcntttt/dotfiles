# Instrucciones para desarrollo de software

## Prioridades

1. Prioriza el rendimiento.
2. Prioriza la fiabilidad.
3. Mantén un comportamiento predecible bajo carga y durante fallos (reinicios de sesión, reconexiones y streams parciales).

Si hay que elegir entre alternativas, prioriza la corrección y la robustez por sobre la conveniencia a corto plazo.

## Mantenibilidad

La mantenibilidad a largo plazo es una prioridad. Si agregas funcionalidad, revisa primero si existe lógica compartida que pueda extraerse a un módulo separado. La lógica duplicada entre varios archivos es una señal de mal diseño.

No evites cambiar código existente cuando sea necesario. No tomes atajos agregando lógica local para resolver problemas que deberían abordarse de forma compartida.

## Textos visibles

Respeta siempre la ortografía del español: usa tildes (acentos) y la letra ñ correctamente en todos los textos visibles para el usuario.

## Herramientas

El shell del usuario es Fish. Tenlo en cuenta al sugerir comandos para ejecutar; puedes seguir usando Bash para realizar tus comprobaciones.

## Interfaces frontend

- Si el usuario está eligiendo, usa un dropdown.
- Si el usuario está leyendo, usa un popover.
