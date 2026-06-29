#!/usr/bin/env bash
# PreToolUse(Edit|Write|MultiEdit) — bloque l'écriture sur fichiers sensibles/générés.
# Exit 2 = BLOCAGE réel (exit 1 ne ferait qu'avertir). Le message stderr
# est renvoyé à Claude comme raison du refus.

input=$(cat)

extract_path() {
  if command -v jq >/dev/null 2>&1; then
    printf '%s' "$input" | jq -r '.tool_input.file_path // empty' 2>/dev/null
  elif command -v python3 >/dev/null 2>&1; then
    printf '%s' "$input" | python3 -c 'import sys,json; print(json.load(sys.stdin).get("tool_input",{}).get("file_path",""))' 2>/dev/null
  fi
}

file=$(extract_path)
[ -z "$file" ] && exit 0
base=$(basename "$file")

# --- Secrets / credentials ---
case "$file" in
  *.env|*/.env|*/.env.*|*.pem|*.key|*/secrets/*|*/credentials*)
    echo "Blocage : '$file' est un fichier sensible (secret/credentials). Édition refusée." >&2
    exit 2
    ;;
esac

# --- Fichiers générés : à régénérer, jamais à éditer à la main ---
case "$base" in
  *.generated.*|*_pb2.py|*.g.dart|*.lock)
    echo "Blocage : '$file' est généré. À régénérer via l'outil de codegen, pas à éditer à la main." >&2
    exit 2
    ;;
esac

exit 0
