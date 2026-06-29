# Notebooklm — Vault vers livrables multimedia

Orchestre le pipeline vault -> NotebookLM -> livrable (podcast, mindmap, study-guide, infographic).
S'appuie sur la lib Python notebooklm-py (github.com/teng-lin/notebooklm-py).

## Prerequis

- Python 3.8+
- pip install notebooklm-py
- Compte Google avec acces NotebookLM

## Etapes

1. **Selection** — identifier les notes wiki a utiliser comme sources (via pattern ou liste explicite)
2. **Notebook** — creer ou recuperer le notebook NotebookLM correspondant
3. **Sources** — injecter chaque note .md comme source dans le notebook
4. **Generation** — demander a NotebookLM le livrable voulu (audio_overview | mindmap | study_guide | ...)
5. **Download** — recuperer le fichier et le sauvegarder dans wiki/Resources/

<!-- TODO: detailler les commandes exactes depuis le transcript video -->

## Output attendu

Fichier livrable (MP3 / PDF / JSON / MD selon type) depose dans wiki/Resources/
avec une note index correspondante.

## Regles

- Ne jamais overwriter un livrable existant sans confirmation explicite
- Toujours logger l'operation dans wiki/Daily/{date}.md
- Les sources passees a NotebookLM doivent etre des notes wiki validees (pas de raw/)
