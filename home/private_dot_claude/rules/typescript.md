---
description: Conventions TypeScript
paths: ["**/*.ts", "**/*.tsx", "**/tsconfig*.json"]
---

# TypeScript

- `strict: true` dans tsconfig ; jamais `any` — préférer `unknown` puis narrowing.
- Modéliser les états avec des unions discriminées ; valider les frontières runtime avec Zod.
- `const`/`readonly` par défaut ; éviter les mutations en place.
- ESM (pas CommonJS) ; imports nommés pour le tree-shaking.
- Lint/format : Biome (ou ESLint + Prettier si le projet est déjà dessus).
- Préférer les types dérivés (`ReturnType`, `Pick`, etc.) à la duplication de formes.
