# ~/.config/fish/config.fish

# ── Environnement ────────────────────────────────────────────
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx PIP_REQUIRE_VIRTUALENV true # garde-fou pip (belt-and-suspenders, même si uv reste l'outil)

set -gx PNPM_HOME "$HOME/.local/share/pnpm"

# ── PATH ─────────────────────────────────────────────────────
# fish_add_path : idempotent, dédoublonne, gère l'ordre. Remplace
# avantageusement les `set -gx PATH ...` + gardes `contains/string match`.
fish_add_path -g ~/.npm-global/bin $PNPM_HOME ~/.local/bin

# ── CUDA / PyTorch ───────────────────────────────────────────
# Gardé par `test -d` → la config reste portable sur les machines sans CUDA
# (utile vu que tout ça part dans chezmoi et se déploie partout).
if test -d /opt/cuda
    set -gx CUDA_HOME /opt/cuda
    set -gx PYTORCH_CUDA_ALLOC_CONF expandable_segments:True
    fish_add_path -g $CUDA_HOME/bin
    set -gx LD_LIBRARY_PATH $CUDA_HOME/lib64 $LD_LIBRARY_PATH
end

# ── Neovim ───────────────────────────────────────────────────
# ⚠ LV_BRANCH est la variable d'install de *LunarVim* et pointe vers Neovim 0.9.
#   Si on est passé à LazyVim, c'est du mort → à supprimer. Décommenter
#   uniquement si LunarVim est encore réellement utilisé.
# set -gx LV_BRANCH release-1.4/neovim-0.9

alias vi=nvim # (cohérent de le déplacer en `abbr` dans conf.d/abbr.fish)

# ── Interactif uniquement ────────────────────────────────────
if status is-interactive
    # fastfetch une seule fois par terminal : pas dans les shells imbriqués
    # ni les splits tmux (sinon ça spamme et ça ralentit l'ouverture).
    if test "$SHLVL" -le 1; and not set -q TMUX
        fastfetch
    end

    # starship n'a de sens qu'en interactif → on évite un spawn inutile
    # dans les shells de scripts.
    starship init fish | source
end
