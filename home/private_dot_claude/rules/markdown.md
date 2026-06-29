---
description: Conventions Markdown
paths: ["**/*.md", "**/*.markdown"]
---

# Markdown

## Structure

- Un seul titre H1 par document, en première ligne ; ne jamais sauter de niveau (`#` → `##` → `###`).
- Titres ATX (`#`), jamais soulignés (style Setext).
- Une ligne vide avant et après titres, listes et blocs de code (compatibilité CommonMark).
- Une phrase par ligne (semantic line breaks) : pas de retour dur au milieu d'une phrase — diffs git plus propres.

## Contenu

- Listes à puces : marqueur `-` partout (cohérent avec prettier/biome) ; imbrication à 2 espaces.
- Liens descriptifs : `[guide d'install](…)`, jamais « cliquez ici » ni l'URL nue.
- Liens internes au dépôt en relatif (`./docs/api.md`), pas en absolu.
- Images : toujours un texte alternatif (`![schéma du flux](…)`).
- Blocs de code toujours clôturés et avec le langage annoté (`python, `bash…).
- Tableaux réservés aux données réellement tabulaires ; sinon une liste.

## Hygiène

- Pas d'espaces en fin de ligne ; fichier terminé par un unique saut de ligne.
- Pas de HTML brut sauf nécessité réelle.
- Métadonnées éventuelles en frontmatter YAML en tête (`--- … ---`).
- Régler les exceptions dans `.markdownlint*` plutôt que de les ignorer au cas par cas.
