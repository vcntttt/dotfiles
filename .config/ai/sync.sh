#!/usr/bin/env bash
# ============================================================
# sync.sh — Sincroniza configuración de IA entre agentes
# ============================================================
# Toma la definición canónica de MCP desde mcp.json,
# mergea con secrets locales (mcp.local.json), y escribe
# en el formato nativo de cada agente.
#
# Agentes: Codex, OpenCode
# ============================================================
set -euo pipefail

AI_DIR="$(cd "$(dirname "$0")" && pwd)"
MCP_CANONICAL="$AI_DIR/mcp.json"
MCP_LOCAL="$AI_DIR/mcp.local.json"
PI_SETTINGS="$AI_DIR/pi.settings.json"
INSTRUCTIONS_DIR="$AI_DIR/instructions"
MARKER_START="# ~ ai-dotfiles: mcp start ~"
MARKER_END="# ~ ai-dotfiles: mcp end ~"

# ----------------------------------------------------------
# merge_mcp(agent) — mergea canonical + local, filtra por
#                    agente, imprime JSON por stdout
# ----------------------------------------------------------
merge_mcp() {
  local agent="$1"
  python3 -c "
import json, sys

with open('$MCP_CANONICAL') as f:
    canonical = json.load(f)

try:
    with open('$MCP_LOCAL') as f:
        local = json.load(f)
except FileNotFoundError:
    local = {}

def deep_merge(base, override):
    result = base.copy()
    for k, v in override.items():
        if k in result and isinstance(result[k], dict) and isinstance(v, dict):
            result[k] = deep_merge(result[k], v)
        else:
            result[k] = v
    return result

merged = deep_merge(canonical, local)

# No continuar con credenciales incompletas: evita sobrescribir las
# configuraciones de los agentes con headers vacíos.
for name, cfg in merged.items():
    if not isinstance(cfg, dict):
        continue
    missing_headers = [
        key for key, value in cfg.get('headers', {}).items()
        if value == ''
    ]
    if missing_headers:
        keys = ', '.join(missing_headers)
        raise SystemExit(
            f'MCP {name!r} requiere secrets en mcp.local.json: {keys}'
        )

# Limpiar campos meta
for meta in ('\$schema', 'description', 'notes'):
    merged.pop(meta, None)

# Filtrar por agente y limpiar campo 'agents'
for name in list(merged.keys()):
    cfg = merged[name]
    agent_list = cfg.pop('agents', ['codex', 'opencode'])
    if '$agent' not in agent_list:
        del merged[name]
        continue
    # OpenCode explícitamente necesita 'enabled'
    if '$agent' == 'opencode':
        cfg['enabled'] = cfg.get('enabled', True)

print(json.dumps(merged, indent=2))
"
}

# ----------------------------------------------------------
# toml_from_json() — lee JSON de stdin, escribe TOML a stdout
# ----------------------------------------------------------
toml_from_json() {
  python3 -c "
import json, sys
servers = json.load(sys.stdin)
for name, config in servers.items():
    print(f'[mcp_servers.{name}]')
    print(f'url = \"{config[\"url\"]}\"')
    headers = {k: v for k, v in config.get('headers', {}).items() if v}
    if headers:
        items = ', '.join(f'\"{k}\" = \"{v}\"' for k, v in headers.items())
        print(f'http_headers = {{ {items} }}')
    print()
"
}

# ----------------------------------------------------------
# inject_toml(config_file) — reemplaza/repara la sección MCP
#  1. Quita bloque entre marcadores (si existe)
#  2. Quita secciones [mcp_servers.*] legacy (sin marcadores)
#  3. Agrega nuevo bloque con marcadores
# ----------------------------------------------------------
inject_toml() {
  local config_file="$1"
  local tmp_body
  tmp_body=$(mktemp)
  cat > "$tmp_body"

  python3 -c "
import re
import sys

config_file = '$config_file'
body_file = '$tmp_body'
marker_start = '$MARKER_START'
marker_end = '$MARKER_END'

with open(body_file) as f:
    content = f.read()

with open(config_file) as f:
    text = f.read()

# 1. Remove existing marker block (inclusive)
pattern = re.escape(marker_start) + r'.*?' + re.escape(marker_end)
text, n = re.subn(pattern, '', text, flags=re.DOTALL)

# 2. Remove legacy [mcp_servers.*] sections (not between markers,
#    since markers were already stripped above)
lines = text.split('\n')
result = []
i = 0
while i < len(lines):
    line = lines[i]
    if re.match(r'^\[mcp_servers\.', line):
        # Skip this line and subsequent indented/data lines until next [ or EOF
        i += 1
        while i < len(lines):
            next_line = lines[i]
            if next_line.startswith('['):
                break
            i += 1
        # La sección termina únicamente al encontrar otra tabla TOML
        continue
    result.append(line)
    i += 1

text = '\n'.join(result)

# 3. Append new MCP block with markers
block = marker_start + '\n' + content + marker_end
text = text.rstrip() + '\n\n' + block + '\n'

with open(config_file, 'w') as f:
    f.write(text)
"

  rm -f "$tmp_body"
}

# ----------------------------------------------------------
# sync_opencode
# ----------------------------------------------------------
sync_opencode() {
  local config_file="$HOME/.config/opencode/opencode.json"

  if [ ! -f "$config_file" ]; then
    echo "⚠  OpenCode: no se encontró $config_file, se salta"
    return
  fi

  echo "  OpenCode → actualizando MCP..."
  local mcp_json
  mcp_json=$(merge_mcp "opencode")

  jq \
    --argjson mcp "$mcp_json" \
    --arg general "$INSTRUCTIONS_DIR/general.md" \
    --arg agent "$INSTRUCTIONS_DIR/opencode.md" \
    '.mcp = $mcp | .instructions = [$general, $agent]' \
    "$config_file" > "${config_file}.tmp" && \
    mv "${config_file}.tmp" "$config_file"
  chmod 600 "$config_file"

  echo "✓  OpenCode: servidores MCP sincronizados"
}

# ----------------------------------------------------------
# ensure_codex_rmcp — activa el cliente MCP remoto requerido por
#                     la autenticación OAuth de Linear
# ----------------------------------------------------------
ensure_codex_rmcp() {
  local config_file="$1"

  python3 - "$config_file" <<'PY'
import sys

config_file = sys.argv[1]
key = 'experimental_use_rmcp_client = true'

with open(config_file) as f:
    lines = f.read().splitlines()

features_index = next(
    (i for i, line in enumerate(lines) if line.strip() == '[features]'),
    None,
)

if features_index is None:
    lines.extend(['', '[features]', key])
else:
    section_end = len(lines)
    for i in range(features_index + 1, len(lines)):
        if lines[i].startswith('['):
            section_end = i
            break

    key_index = next(
        (
            i for i in range(features_index + 1, section_end)
            if lines[i].split('=', 1)[0].strip() == 'experimental_use_rmcp_client'
        ),
        None,
    )
    if key_index is None:
        lines.insert(features_index + 1, key)
    else:
        lines[key_index] = key

with open(config_file, 'w') as f:
    f.write('\n'.join(lines) + '\n')
PY
}

# ----------------------------------------------------------
# sync_codex
# ----------------------------------------------------------
sync_codex() {
  local config_file="$HOME/.codex/config.toml"

  if [ ! -f "$config_file" ]; then
    echo "⚠  Codex: no se encontró $config_file, se salta"
    return
  fi

  echo "  Codex → actualizando MCP..."
  ensure_codex_rmcp "$config_file"
  merge_mcp "codex" | toml_from_json | inject_toml "$config_file"
  chmod 600 "$config_file"

  echo "✓  Codex: servidores MCP sincronizados"
}

# ----------------------------------------------------------
# sync_pi — actualiza settings de pi y preserva claves locales
#             que no estén definidas en la fuente canónica
# ----------------------------------------------------------
sync_pi() {
  local config_file="$HOME/.pi/agent/settings.json"
  local config_dir
  config_dir="$(dirname "$config_file")"
  mkdir -p "$config_dir"

  if [ -f "$config_file" ]; then
    jq -s '.[0] * .[1]' "$config_file" "$PI_SETTINGS" > "${config_file}.tmp"
    mv "${config_file}.tmp" "$config_file"
  else
    cp "$PI_SETTINGS" "$config_file"
  fi
  chmod 600 "$config_file"

  echo "✓  pi: configuración sincronizada"
}

# ----------------------------------------------------------
# main
# ----------------------------------------------------------
main() {
  echo "=== AI Agent MCP Sync ==="
  echo ""

  if [ ! -f "$MCP_CANONICAL" ] || [ ! -f "$PI_SETTINGS" ] || \
    [ ! -f "$INSTRUCTIONS_DIR/general.md" ] || \
    [ ! -f "$INSTRUCTIONS_DIR/opencode.md" ] || \
    [ ! -f "$INSTRUCTIONS_DIR/codex.md" ] || \
    [ ! -f "$INSTRUCTIONS_DIR/pi.md" ]; then
    echo "ERROR: faltan archivos de configuración en $AI_DIR" >&2
    exit 1
  fi

  if [ ! -f "$MCP_LOCAL" ]; then
    echo "ERROR: no se encuentra $MCP_LOCAL" >&2
    echo "Copia mcp.local.json.example y completa sus secrets." >&2
    exit 1
  fi
  chmod 600 "$MCP_LOCAL"

  sync_opencode
  sync_codex
  sync_pi

  echo ""
  echo "=== Hecho ==="
}

# Solo ejecutar main si se invoca directamente (no al hacer source)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi
