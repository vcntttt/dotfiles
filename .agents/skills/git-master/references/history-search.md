# Modo búsqueda histórica

## Elegir la herramienta

| Pregunta | Comando |
|---|---|
| cuándo se añadió o eliminó una cadena | `git log -S "cadena" --oneline` |
| qué commits tocaron un patrón | `git log -G "patrón" --oneline` |
| quién escribió una línea | `git blame [-L inicio,fin] archivo` |
| cuándo empezó un bug | `git bisect` |
| historial de un archivo | `git log --follow --oneline -- archivo` |

Usa `--all` cuando haya que localizar código eliminado en otras ramas. Añade `-p` cuando el usuario necesite entender el cambio, no solo identificarlo.

## Bisect

```bash
git bisect start
git bisect bad HEAD
git bisect good <commit-conocido-bueno>
# probar cada revisión y marcarla good/bad
git bisect reset
```

Si existe una prueba determinista, puede usarse `git bisect run <comando>`.

## Informe

Devuelve consulta, tipo de búsqueda, comando utilizado, commits relevantes, autor/fecha cuando aporte valor y una conclusión accionable. No modifiques historia durante una búsqueda.
