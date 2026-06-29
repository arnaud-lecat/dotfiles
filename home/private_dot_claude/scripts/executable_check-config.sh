#!/usr/bin/env bash
# check-config.sh — audite la config ~/.claude (santé, budget, cohérence).
# Erreurs => exit 1 (casse une CI / un pre-commit). Avertissements => non bloquants.
# Respecte CLAUDE_CONFIG_DIR si défini (sinon ~/.claude).

CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"

# Seuils (ajustables)
MAX_CLAUDE_MD=100   # CLAUDE.md est chargé en entier à chaque session
MAX_RULE=60         # une règle modulaire doit rester courte

errors=0
warns=0
red=$'\033[31m'; yel=$'\033[33m'; grn=$'\033[32m'; dim=$'\033[2m'; rst=$'\033[0m'
err()  { echo "${red}✗ ERREUR${rst}  $1"; errors=$((errors+1)); }
warn() { echo "${yel}!  ATTENTION${rst} $1"; warns=$((warns+1)); }
ok()   { echo "${grn}✓${rst} ${dim}$1${rst}"; }

echo "── Audit de $CLAUDE_DIR ──"

# 1. CLAUDE.md : présence + budget de lignes (toujours chargé)
if [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
  n=$(wc -l < "$CLAUDE_DIR/CLAUDE.md")
  if [ "$n" -gt "$MAX_CLAUDE_MD" ]; then
    warn "CLAUDE.md fait $n lignes (> $MAX_CLAUDE_MD). Sortir du contenu vers rules/ ou des skills."
  else
    ok "CLAUDE.md : $n lignes (budget $MAX_CLAUDE_MD)"
  fi
else
  err "CLAUDE.md introuvable"
fi

# 2. Règles modulaires : budget + frontmatter paths:
if [ -d "$CLAUDE_DIR/rules" ]; then
  for f in "$CLAUDE_DIR"/rules/*.md; do
    [ -e "$f" ] || continue
    n=$(wc -l < "$f"); name=$(basename "$f")
    [ "$n" -gt "$MAX_RULE" ] && warn "rules/$name fait $n lignes (> $MAX_RULE)."
    # frontmatter bien fermé ?
    if head -1 "$f" | grep -q '^---$'; then
      if ! awk 'NR>1 && /^---$/{found=1; exit} END{exit !found}' "$f"; then
        err "rules/$name : frontmatter ouvert mais jamais fermé (--- manquant)."
      elif ! grep -q '^paths:' "$f"; then
        warn "rules/$name : pas de 'paths:' => chargée en permanence (perd l'intérêt du conditionnel)."
      else
        ok "rules/$name : $n lignes, paths: présent"
      fi
    else
      warn "rules/$name : aucun frontmatter (chargée en permanence)."
    fi
  done
fi

# 3. settings.json : JSON valide
SETTINGS="$CLAUDE_DIR/settings.json"
if [ -f "$SETTINGS" ]; then
  if python3 -c "import json,sys; json.load(open(sys.argv[1]))" "$SETTINGS" 2>/dev/null; then
    ok "settings.json : JSON valide"
    # 4. Hooks référencés : le script existe et est exécutable
    python3 - "$SETTINGS" <<'PY' | while IFS= read -r cmd; do
import json, sys, re
d = json.load(open(sys.argv[1]))
for ev, groups in (d.get("hooks") or {}).items():
    for g in groups:
        for h in g.get("hooks", []):
            c = h.get("command", "")
            if c:
                print(c)
PY
      # n'évaluer que le premier token (le chemin du script), variables expansées
      script=$(printf '%s' "$cmd" | awk '{print $1}')
      script=$(eval echo "$script")
      case "$script" in
        */*)  # ressemble à un chemin de fichier
          if [ ! -e "$script" ]; then
            err "hook référencé introuvable : $script"
          elif [ ! -x "$script" ]; then
            err "hook non exécutable (chmod +x) : $script"
          else
            ok "hook OK : $script"
          fi
          ;;
        *) : ;;  # commande inline (ex. echo …), on ignore
      esac
    done
  else
    err "settings.json : JSON INVALIDE"
  fi
else
  warn "settings.json absent"
fi

# 5. Tous les scripts de hooks sont exécutables
if [ -d "$CLAUDE_DIR/hooks" ]; then
  for s in "$CLAUDE_DIR"/hooks/*.sh; do
    [ -e "$s" ] || continue
    [ -x "$s" ] || err "hooks/$(basename "$s") n'est pas exécutable (chmod +x)."
  done
fi

# 6. Doublons de titres entre règles (signal de duplication)
if [ -d "$CLAUDE_DIR/rules" ]; then
  dup=$(grep -rhoE '^#{1,2} .+' "$CLAUDE_DIR"/rules/*.md 2>/dev/null | sort | uniq -d)
  [ -n "$dup" ] && warn "titres dupliqués entre règles (possible redondance) :
$(printf '%s' "$dup" | sed 's/^/      /')"
fi

# 7. Skills : frontmatter (name + description) + scripts exécutables
if [ -d "$CLAUDE_DIR/skills" ]; then
  for sk in "$CLAUDE_DIR"/skills/*/; do
    [ -d "$sk" ] || continue
    name=$(basename "$sk")
    md="$sk/SKILL.md"
    if [ ! -f "$md" ]; then
      err "skills/$name : SKILL.md manquant."
      continue
    fi
    # frontmatter présent et fermé ?
    if ! head -1 "$md" | grep -q '^---$'; then
      err "skills/$name : SKILL.md sans frontmatter."
    elif ! awk 'NR>1 && /^---$/{f=1; exit} END{exit !f}' "$md"; then
      err "skills/$name : frontmatter jamais fermé (--- manquant)."
    else
      miss=""
      grep -q '^name:' "$md" || miss="name"
      grep -q '^description:' "$md" || miss="${miss:+$miss, }description"
      if [ -n "$miss" ]; then
        err "skills/$name : champ(s) requis manquant(s) dans le frontmatter : $miss."
      else
        ok "skills/$name : SKILL.md (name + description présents)"
      fi
    fi
    # scripts bundlés exécutables ?
    for s in "$sk"scripts/*.sh; do
      [ -e "$s" ] || continue
      [ -x "$s" ] || err "skills/$name/scripts/$(basename "$s") n'est pas exécutable (chmod +x)."
    done
  done
fi

# 8. Lint optionnels (si installés)
command -v shellcheck >/dev/null 2>&1 && {
  shellcheck "$CLAUDE_DIR"/hooks/*.sh "$CLAUDE_DIR"/scripts/*.sh "$CLAUDE_DIR"/skills/*/scripts/*.sh >/dev/null 2>&1 \
    && ok "shellcheck : scripts propres" \
    || warn "shellcheck signale des problèmes (lancer : shellcheck $CLAUDE_DIR/hooks/*.sh)."
}

echo "──"
if [ "$errors" -gt 0 ]; then
  echo "${red}$errors erreur(s)${rst}, $warns avertissement(s)."
  exit 1
else
  echo "${grn}OK${rst} — 0 erreur, $warns avertissement(s)."
  exit 0
fi
