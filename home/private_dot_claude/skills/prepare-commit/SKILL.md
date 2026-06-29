---
name: prepare-commit
description: >
  Préparer un commit ou une pull request propres : lancer le gate qualité (format, lint,
  typecheck, tests) sur les fichiers modifiés, découper en commits logiques, et rédiger des
  messages en Conventional Commits ainsi qu'une description de PR. À utiliser quand on demande
  de committer, de préparer/ouvrir une PR, de « finaliser » des changements, ou simplement de
  rédiger un message de commit à partir d'un diff.
---

# Préparer un commit / une PR

> Workflow de livraison délibéré : on vérifie tout, puis on rédige. Complète les hooks de
> formatage (qui agissent à chaque édition) ; ici on fait le contrôle complet au moment de livrer.

## Procédure

### 1. État des lieux
- `git status --porcelain` puis `git --no-pager diff` (et `--cached`) pour voir ce qui change réellement.
- Ne JAMAIS faire `git add .` à l'aveugle. Identifier les fichiers à committer ; écarter tout `.env`, secret, artefact de build ou fichier non lié.

### 2. Gate qualité
- Lancer `scripts/gate.sh` (dans ce dossier de skill) depuis la racine du dépôt.
- Il préfère les recettes `just` (`just check`/`lint`/`test`) si un Justfile existe, sinon les outils par langage détecté.
- Si le gate échoue : **s'arrêter**, rapporter ce qui casse, ne pas committer. Laisser l'utilisateur trancher.

### 3. Découpage
- Un commit = un changement logique cohérent. Si le diff mêle plusieurs intentions (feat + refactor + fix), proposer de découper et stager par lots (`git add -p` ou par fichier).

### 4. Message — Conventional Commits
- Format : `type(scope): sujet à l'impératif` (≤ 72 caractères), puis un corps qui explique le **pourquoi**, pas le quoi.
- Types : `feat`, `fix`, `refactor`, `perf`, `test`, `docs`, `build`, `ci`, `chore`, `style`.
- Rupture d'API : `type!: …` et/ou footer `BREAKING CHANGE: …`.
- Référencer l'issue en footer si pertinent (`Refs #123`).
- NE PAS ajouter de footer d'attribution IA (« Generated with… ») sauf demande explicite.

### 5. PR (uniquement si demandé)
- Titre = commit principal en Conventional Commits.
- Corps concis : contexte/problème, résumé des changements, comment tester, points d'attention pour le relecteur.
- Ne pas pousser ni ouvrir la PR sans accord explicite.

## Garde-fous
- Jamais de `git push` automatique sauf demande.
- Jamais committer un secret, un `.env`, un fichier généré ou un lock non voulu.
- Si rien n'est à committer, le dire ; ne pas inventer de changement.
