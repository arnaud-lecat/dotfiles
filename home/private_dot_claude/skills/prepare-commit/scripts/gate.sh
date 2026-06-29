#!/usr/bin/env bash
# gate.sh — contrôle qualité avant commit/PR.
# Détecte les langages des fichiers modifiés, préfère les recettes `just`,
# sinon lance les outils par langage.
# Outil ABSENT => avertissement (non bloquant). Outil présent qui ÉCHOUE => erreur (exit 1).

set -uo pipefail
root=$(git rev-parse --show-toplevel 2>/dev/null) || { echo "Pas dans un dépôt git."; exit 0; }
cd "$root" || exit 0

red=$'\033[31m'; yel=$'\033[33m'; grn=$'\033[32m'; rst=$'\033[0m'
fail=0
err()  { echo "${red}✗${rst} $1"; fail=1; }
warn() { echo "${yel}!${rst} $1"; }
ok()   { echo "${grn}✓${rst} $1"; }

# run_check <label> <cmd> [args...] : lance <cmd> si présent, sinon avertit.
run_check() {
  local label="$1"; shift
  if command -v "$1" >/dev/null 2>&1; then
    if "$@" >/dev/null 2>&1; then ok "$label"; else err "$label a échoué"; fi
  else
    warn "$label ignoré ($1 absent)"
  fi
}

# Fichiers modifiés : staged + non staged + non suivis
changed=$(git status --porcelain | awk '{print $NF}')
[ -z "$changed" ] && { echo "Rien à vérifier (aucun changement)."; exit 0; }
has() { printf '%s\n' "$changed" | grep -qiE "$1"; }

echo "── Gate qualité ──"

# --- Préférence : recettes just ---
if command -v just >/dev/null 2>&1 && { [ -f justfile ] || [ -f Justfile ] || [ -f .justfile ]; }; then
  recipes=$(just --summary 2>/dev/null)
  used_just=0
  for r in check lint test; do
    if printf '%s' "$recipes" | tr ' ' '\n' | grep -qx "$r"; then
      if just "$r" >/dev/null 2>&1; then ok "just $r"; else err "just $r a échoué"; fi
      used_just=1
    fi
  done
  if [ "$used_just" = 1 ]; then
    echo "──"
    [ "$fail" = 0 ] && echo "${grn}Gate OK${rst}" || echo "${red}Gate en échec${rst}"
    exit "$fail"
  fi
fi

# --- Sinon, par langage détecté ---
if has '\.py$'; then
  run_check "ruff format" ruff format --check .
  run_check "ruff lint"   ruff check .
  run_check "mypy"        mypy .
  run_check "pytest"      pytest -q
fi
if has '\.php$'; then
  run_check "php-cs-fixer" php-cs-fixer fix --dry-run --quiet
  [ -x vendor/bin/phpstan ] && { vendor/bin/phpstan analyse -q >/dev/null 2>&1 && ok "phpstan" || err "phpstan"; }
  [ -x vendor/bin/phpunit ] && { vendor/bin/phpunit >/dev/null 2>&1 && ok "phpunit" || err "phpunit"; }
fi
if has '\.(ts|tsx|js|jsx)$'; then
  if command -v biome >/dev/null 2>&1; then
    biome check . >/dev/null 2>&1 && ok "biome" || err "biome"
  elif command -v pnpm >/dev/null 2>&1; then
    pnpm biome check . >/dev/null 2>&1 && ok "biome (pnpm)" || warn "biome non lancé"
  else
    warn "biome ignoré (absent)"
  fi
  command -v pnpm >/dev/null 2>&1 && { pnpm exec tsc --noEmit >/dev/null 2>&1 && ok "tsc" || err "tsc"; }
fi
if has '\.rs$'; then
  run_check "cargo fmt"    cargo fmt --check
  run_check "cargo clippy" cargo clippy -- -D warnings
  run_check "cargo test"   cargo test
fi

echo "──"
if [ "$fail" = 0 ]; then echo "${grn}Gate OK${rst}"; else echo "${red}Gate en échec${rst}"; fi
exit "$fail"
