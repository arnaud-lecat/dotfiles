---
description: Conventions React
paths: ["**/*.jsx", "**/*.tsx"]
---

# React

- Composants fonctionnels + hooks uniquement ; pas de composants classe.
- Règles des hooks : appel au niveau racine, jamais conditionnel ; tableaux de dépendances complets et honnêtes.
- `useEffect` réservé à la synchro avec un système externe — pas pour dériver une valeur (la calculer au rendu).
- État minimal : dériver plutôt que dupliquer ; remonter l'état partagé au plus proche ancêtre commun.
- Listes : `key` stable et unique (pas l'index de tableau si l'ordre peut changer).
- Mémoïsation (`memo`/`useMemo`/`useCallback`) seulement si mesurée nécessaire, pas par défaut.
- Composants petits et à responsabilité unique ; extraire la logique réutilisable en hooks custom.
- Inputs contrôlés ; composition plutôt qu'héritage ; Context seulement quand le prop drilling devient réel.
- État serveur géré par une lib dédiée (TanStack Query) plutôt qu'un `useEffect` + `fetch` à la main.
