---
description: Conventions PHP (8+, Symfony/DDD)
paths: ["**/*.php", "**/composer.json"]
---

# PHP

> S'applique au PHP 8+. Sur un codebase legacy < 8, suivre les conventions du dépôt — ces règles ne s'appliquent pas.

- `declare(strict_types=1);` en tête de chaque fichier ; types stricts sur propriétés, args et retours.
- Tirer parti du langage : promotion de propriétés, `readonly`, enums, named arguments, `match`.
- `final` par défaut sur les classes ; immutabilité quand c'est possible (value objects).
- Toolchain : PHPStan niveau max, PHP-CS-Fixer (PER-CS / PSR-12), Rector pour les montées de version.
- Respecter PSR-4 (autoload) ; pas de logique dans les constructeurs au-delà de l'assignation.
- DDD tactique quand le contexte s'y prête (entities, VO, repositories en interface dans le domaine).
