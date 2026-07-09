# AI Agent Configuration Centralizada

Este directorio centraliza la configuración común de los agentes de IA.
Los MCP se sincronizan con Codex y OpenCode; pi no tiene un cliente MCP nativo.

## Estructura

```
.config/ai/
├── AGENTS.md            ← Este archivo
├── mcp.json             ← Definiciones canónicas de servidores MCP
├── mcp.local.json       ← Secrets/API keys (gitignorado)
├── mcp.local.json.example ← Ejemplo para otros entornos
├── pi.settings.json     ← Configuración canónica de pi
├── instructions/        ← Instrucciones generales y específicas
│   ├── general.md
│   ├── opencode.md
│   ├── codex.md
│   └── pi.md
└── sync.sh              ← Script para sincronizar MCP y pi
```

## Instrucciones globales

Las instrucciones tienen dos niveles:

- `instructions/general.md`: reglas compartidas por todos los agentes.
- `instructions/{agente}.md`: reglas específicas de cada agente.

Las rutas globales usan symlinks:

```text
~/.config/opencode/AGENTS.md → instructions/opencode.md
~/.codex/AGENTS.md           → instructions/codex.md
~/.pi/agent/AGENTS.md        → instructions/pi.md
```

OpenCode también recibe ambos archivos mediante la clave `instructions` de su
configuración global. Codex y pi reciben el archivo específico, que referencia
explícitamente el archivo general.

Las instrucciones por proyecto (`AGENTS.md` o `CLAUDE.md`) siguen siendo
adicionales y pueden especializar el comportamiento del agente.

## MCP Servers

Todos los servidores MCP se definen UNA sola vez en `mcp.json`:

```json
{
  "mi-servidor": {
    "type": "remote",
    "url": "https://ejemplo.com/mcp",
    "headers": {
      "API_KEY": ""
    },
    "agents": ["codex", "opencode"]
  }
}
```

- **`agents`**: Lista de agentes que recibirán este servidor.
- Los valores sensibles (API keys) van en `mcp.local.json` (gitignorado) y se mergean automáticamente.
- `mcp.local.json` es obligatorio cuando existe un header sensible; el sync falla si falta o está vacío.
- Los archivos que contienen secrets se mantienen con permisos `0600`.

### Linear MCP

Linear usa OAuth; no se guardan tokens en este repositorio.
Después de ejecutar el sync, autentica cada agente una sola vez:

```bash
# Codex
codex mcp login linear

# OpenCode
opencode mcp auth linear
```

Para Codex, el sync activa automáticamente:

```toml
[features]
experimental_use_rmcp_client = true
```

La URL oficial para ambos es `https://mcp.linear.app/mcp`.

### Agregar un servidor MCP nuevo

1. Editar `.config/ai/mcp.json` y agregar la definición
2. Si requiere API key, agregarla en `.config/ai/mcp.local.json`
3. Ejecutar `.config/ai/sync.sh`

## Agentes soportados

| Agente | Archivo de configuración | Formato MCP |
|--------|--------------------------|-------------|
| **Codex** | `~/.codex/config.toml` | `[mcp_servers.*]` (TOML) |
| **OpenCode** | `~/.config/opencode/opencode.json` | `mcp.*` (JSON) |
| **pi** | `~/.pi/agent/settings.json` | Settings y paquetes; no tiene MCP nativo |

## sync.sh

El script `sync.sh` hace lo siguiente:

1. Lee `mcp.json` + `mcp.local.json` y mergea los datos
2. Filtra servidores por agente (campo `agents`)
3. Para **OpenCode**: actualiza `~/.config/opencode/opencode.json` con `jq`
4. Para **Codex**: reemplaza la sección `[mcp_servers.*]` en `~/.codex/config.toml` usando marcadores `# ~ ai-dotfiles: mcp start/end ~` y activa el cliente RMCP
5. Para **pi**: sincroniza `pi.settings.json` con `~/.pi/agent/settings.json`, preservando claves desconocidas
6. Para **OpenCode**: registra `general.md` y `opencode.md` mediante `instructions`
7. Verifica que los secrets estén completos y aplica permisos `0600`
8. Es **idempotente** — se puede ejecutar múltiples veces sin duplicar entradas

### Uso diario

```bash
# Después de editar mcp.json o mcp.local.json:
.config/ai/sync.sh
```

### Consideraciones

- Codex y OpenCode pueden tener API keys **diferentes** para el mismo servicio
  (ej: Context7). El sync unifica ambas bajo el valor de `mcp.local.json`.
  Si necesitas keys distintas por agente, avísame y ajustamos el diseño.
- Linear utiliza OAuth independiente por agente; sus tokens se guardan en los
  almacenes locales de Codex/OpenCode, no en `mcp.local.json`.
- Las secciones de Codex que no son MCP (projects, plugins, hooks) se preservan intactas.
- El bloque MCP en Codex está delimitado por marcadores de comentario para
  permitir reemplazos limpios en futuros syncs.
- La configuración general de pi se administra desde `pi.settings.json`.
  Las claves desconocidas que ya existan en el runtime se preservan.
- pi continúa sin soporte MCP nativo; sus integraciones se gestionan mediante paquetes o extensiones.
