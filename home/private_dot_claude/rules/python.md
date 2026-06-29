---
description: Conventions Python
paths: ["**/*.py", "**/pyproject.toml"]
---

# Python

- Type hints partout, vérifiés (`mypy --strict` ou pyright) ; pas de `# type: ignore` sans commentaire.
- `ruff` pour lint + format (remplace black/isort/flake8) ; viser zéro warning.
- `pathlib` plutôt que `os.path` ; f-strings plutôt que `%`/`.format`.
- Données structurées : `@dataclass` (slots) ou Pydantic aux frontières (I/O, API).
- Jamais de défaut mutable en argument ; préférer les fonctions pures.
- Tests : pytest, fixtures plutôt que setup/teardown.
