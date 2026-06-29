#!/usr/bin/env bash
# PostToolUse(Edit|Write|MultiEdit) — formate le fichier touché selon son extension.
# Idempotent, NON bloquant : sort toujours en 0, dégrade en silence si l'outil
# n'est pas installé. (Shebang bash volontaire : indépendant de Fish.)

input=$(cat)

# Extraction robuste du chemin : jq si présent, sinon python3.
extract_path() {
  if command -v jq >/dev/null 2>&1; then
    printf '%s' "$input" | jq -r '.tool_input.file_path // empty' 2>/dev/null
  elif command -v python3 >/dev/null 2>&1; then
    printf '%s' "$input" | python3 -c 'import sys,json; print(json.load(sys.stdin).get("tool_input",{}).get("file_path",""))' 2>/dev/null
  fi
}

file=$(extract_path)
[ -z "$file" ] && exit 0
[ -f "$file" ] || exit 0

# run <cmd> [args...] : exécute seulement si <cmd> est installé, silencieusement.
run() { command -v "$1" >/dev/null 2>&1 && "$@" >/dev/null 2>&1; }

case "$file" in
  *.py)
    run ruff format "$file"
    run ruff check --fix "$file"
    ;;
  *.rs)
    run rustfmt "$file"
    ;;
  *.php)
    run php-cs-fixer fix "$file" --quiet
    ;;
  *.ts|*.tsx|*.js|*.jsx|*.json|*.css|*.html|*.md)
    if command -v biome >/dev/null 2>&1; then
      biome format --write "$file" >/dev/null 2>&1
    else
      run prettier --write "$file"
    fi
    ;;
esac

exit 0
