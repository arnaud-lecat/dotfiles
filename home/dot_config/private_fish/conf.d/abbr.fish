# ~/.config/fish/conf.d/abbr.fish
#
# Abréviations déclaratives (fish 3.6+) : versionnables proprement via chezmoi,
# contrairement aux abbr stockées dans fish_variables.
#
# Rappels syntaxe :
#   -a                  : add
#   --set-cursor / %    : place le curseur après expansion (déclenchée par espace/entrée)
#   --position anywhere : l'abbr s'étend même au milieu d'une commande (ex: pipes)
#   --function          : expansion dynamique calculée par une fonction

status is-interactive; or exit 0

# ─────────────────────────────────────────────────────────────
#  Git — le cœur du réacteur
# ─────────────────────────────────────────────────────────────
abbr -a g git
abbr -a gs git status -sb
abbr -a ga git add
abbr -a gaa git add --all
abbr -a gap git add --patch

abbr -a gc git commit -v
abbr -a gcm --set-cursor git commit -m \"%\"
abbr -a gca git commit --amend
abbr -a gcan git commit --amend --no-edit # ré-amende sans rouvrir l'éditeur

abbr -a gco git checkout
abbr -a gsw git switch
abbr -a gswc git switch -c
abbr -a gb git branch
abbr -a gbd git branch -d

abbr -a gd git diff
abbr -a gds git diff --staged
abbr -a gl git log --oneline --graph --decorate
abbr -a gla git log --oneline --graph --decorate --all

abbr -a gf git fetch --all --prune
abbr -a gpl git pull --ff-only
abbr -a gp git push
abbr -a gpf git push --force-with-lease # jamais --force "sec" : force-with-lease
abbr -a gpu --set-cursor git push -u origin %

# Rebase / merge / cherry-pick (Gitflow, divergences develop↔master)
abbr -a gr git rebase
abbr -a gri --set-cursor git rebase -i HEAD~%
abbr -a grc git rebase --continue
abbr -a gra git rebase --abort
abbr -a gm git merge --no-ff
abbr -a gcp git cherry-pick

# Stash (les fameux conflits de stash)
abbr -a gst git stash push
abbr -a gstp git stash pop
abbr -a gstl git stash list
abbr -a gsts git stash show -p

# Reset / récupération
abbr -a grh git reset HEAD --
abbr -a grhh git reset --hard HEAD
abbr -a gundo git reset --soft HEAD~1 # défait le dernier commit, garde le travail

# WIP express (pour switcher vite sans cérémonie)
abbr -a gwip git add -A && git commit -m \"wip\" --no-verify
abbr -a gunwip git reset --soft HEAD~1

abbr -a lg lazygit

# ─────────────────────────────────────────────────────────────
#  Docker / Compose (stack MariaDB & co)
# ─────────────────────────────────────────────────────────────
abbr -a d docker
abbr -a dc docker compose
abbr -a dcu docker compose up -d
abbr -a dcd docker compose down
abbr -a dcl docker compose logs -f --tail=100
abbr -a dcr docker compose restart
abbr -a dcp docker compose ps
abbr -a dce --set-cursor docker compose exec % bash
abbr -a dprune docker system prune -af --volumes

# ─────────────────────────────────────────────────────────────
#  PHP / Composer / Symfony
# ─────────────────────────────────────────────────────────────
abbr -a co composer
abbr -a ci composer install
abbr -a cu composer update
abbr -a cr composer require
abbr -a crd composer require --dev
abbr -a cda composer dump-autoload -o

abbr -a sf php bin/console
abbr -a sfc php bin/console cache:clear
abbr -a sfr php bin/console debug:router
abbr -a sfm --set-cursor php bin/console make:%
abbr -a sfmm php bin/console make:migration
abbr -a sfmig php bin/console doctrine:migrations:migrate --no-interaction

# Chaîne qualité
abbr -a stan vendor/bin/phpstan analyse
abbr -a csf vendor/bin/php-cs-fixer fix
abbr -a csfd vendor/bin/php-cs-fixer fix --dry-run --diff
abbr -a rect vendor/bin/rector process
abbr -a rectd vendor/bin/rector process --dry-run
abbr -a pu vendor/bin/phpunit
abbr -a puf --set-cursor vendor/bin/phpunit --filter %

# ─────────────────────────────────────────────────────────────
#  Python — uv exclusivement (pas pip)
# ─────────────────────────────────────────────────────────────
abbr -a uvr uv run
abbr -a uva uv add
abbr -a uvad uv add --dev
abbr -a uvs uv sync
abbr -a uvv uv venv
abbr -a uvl uv lock

# ─────────────────────────────────────────────────────────────
#  chezmoi
# ─────────────────────────────────────────────────────────────
abbr -a cm chezmoi
abbr -a cma chezmoi apply
abbr -a cmd chezmoi diff
abbr -a cme --set-cursor chezmoi edit %
abbr -a cmu chezmoi update
abbr -a cmcd chezmoi cd
abbr -a cmadd chezmoi add
abbr -a cmm chezmoi managed

# ─────────────────────────────────────────────────────────────
#  Navigation / système
# ─────────────────────────────────────────────────────────────
abbr -a .. cd ..
abbr -a ... cd ../..
abbr -a .... cd ../../..
abbr -a mkd mkdir -p
abbr -a v nvim
abbr -a c clear

# ─────────────────────────────────────────────────────────────
#  Power-ups fish : --position anywhere (s'étend au milieu d'une ligne)
#  Ex : `cat gros.log G erreur`  →  `cat gros.log | grep erreur`
# ─────────────────────────────────────────────────────────────
abbr -a --position anywhere G '| grep -i'
abbr -a --position anywhere L '| less'
abbr -a --position anywhere H '| head'
abbr -a --position anywhere T '| tail'
abbr -a --position anywhere C '| wc -l'
abbr -a --position anywhere J '| jq'
abbr -a --position anywhere NUL '&>/dev/null'
abbr -a --position anywhere NE '2>/dev/null'

# ─────────────────────────────────────────────────────────────
#  Abbr dynamique (--function) : !! et !$ façon bash, en natif fish
#  `gco BANG`  →  remplace par la dernière branche/argument utile
# ─────────────────────────────────────────────────────────────
function _last_history_item
    history | head -1
end
abbr -a !! --position anywhere --function _last_history_item
