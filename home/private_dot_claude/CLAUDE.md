# Préférences globales

> Global (`~/.claude/CLAUDE.md`) — chargé en entier sur TOUS les projets, à chaque session.
> Donc : rester MINCE. Préférences stables uniquement.
> Spécifique projet → `CLAUDE.md` du dépôt. Conventions par langage → `~/.claude/rules/`.

## Communication

- Répondre en français, registre « on » (pas « tu »).
- Aller à l'essentiel : pas de remplissage, pas de flatterie, pas de récap inutile.
- Annoncer les hypothèses prises plutôt que poser une question quand le contexte permet d'inférer.
- Ne poser une question que si l'ambiguïté bloque réellement le travail.

## Outils par défaut

> Perso : Arch/Manjaro. Boulot : Ubuntu. Shell : Fish.

- **Python** : `uv` exclusivement (jamais `pip`/`venv`/`poetry`). Exécuter avec `uv run`, ajouter avec `uv add`.
- **Tâches répétées** : `just` (Justfile), pas de Makefile.
- **Git** : `lazygit` pour l'interactif ; messages de commit en Conventional Commits.
- **Shell** : Fish — pas de bashismes dans les snippets ; si du bash est nécessaire, le préfixer `bash -c '…'`.
- **Dotfiles** : gérés avec `chezmoi` — proposer `chezmoi edit <fichier>` plutôt que d'éditer la cible directement.
- **Éditeur** : Neovim (LazyVim).
- Commandes shell : proxifiées par `rtk` (Rust Token Killer) via hook, de façon transparente — taper les commandes normalement, ne pas préfixer à la main. rtk proxy <cmd> réservé au debug. Analytics : rtk gain / rtk discover. Référence : ~/.claude/RTK.md (ouvrir au besoin, ne pas charger d'office).

## Code (transverse, tous langages)

- Privilégier la clarté à la concision maligne ; noms explicites.
- Solution la plus simple qui marche ; pas de sur-ingénierie ni d'abstraction prématurée.
- Ne pas ajouter de dépendance sans raison — vérifier ce qui est déjà présent dans le projet.
- Commentaires seulement quand ils expliquent le « pourquoi », jamais le « quoi ».

## Comportement

- Vérifier avant d'affirmer (versions, signatures d'API, options de commandes) plutôt que deviner.
- S'aligner sur les conventions du dépôt courant et sur son `CLAUDE.md` (qui prime sur ce fichier).
- Ne pas créer de fichiers annexes non demandés (README, exemples, scripts de démo).
- Avant un changement large, exposer brièvement le plan plutôt que de tout réécrire d'un coup.
