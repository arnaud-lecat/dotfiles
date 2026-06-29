---
name: ddd
description: >
  Appliquer les patterns Domain-Driven Design lorsqu'une tâche porte sur la modélisation d'un domaine
  métier : bounded contexts, agrégats, entités, value objects, domain events, repositories, anti-corruption layer,
  langage ubiquitaire. À utiliser quand on mentionne DDD, « modèle de domaine », « agrégat », « contexte borné »,
  ou quand on conçoit un domaine métier non trivial. NE PAS appliquer à du CRUD simple ou un domaine anémique :
  une approche en couches/services classique suffit alors.
---

# Domain-Driven Design

> À mobiliser quand la complexité métier le justifie. Sur du CRUD simple, ne pas forcer DDD.

## Stratégique

- Partir du **langage ubiquitaire** : nommer le code d'après le domaine, pas la technique. Le code et les experts métier parlent pareil.
- Identifier les **bounded contexts** : un modèle cohérent par contexte, pas un modèle unique pour toute l'appli.
- Intégrer les contexts via le **context mapping** : ACL (anti-corruption layer), published language, integration events. Pas d'appel direct d'un domaine à un autre.

## Tactique

- **Agrégats** : protègent les invariants. Une transaction = un agrégat modifié. Référencer les autres agrégats par identité (id), pas par objet.
- **Entités** (identité durable) vs **Value Objects** (immuables, égalité par valeur). Préférer un VO pour tout concept sans identité propre (Money, Email, DateRange…).
- **Domain events** pour les effets de bord entre agrégats ; garder le domaine pur, sans I/O.
- **Repositories** : interface dans le domaine, implémentation dans l'infrastructure. Un repository par racine d'agrégat.
- **Application services** : orchestrent (charger, appeler le domaine, persister). Les **règles** vivent dans le domaine, jamais dans l'infra ni dans le service.
- **Anti-corruption layer** à la frontière des systèmes legacy/externes : traduire leur modèle, ne pas le laisser fuir dans le domaine.

## Garde-fous

- Pas d'annotation ORM ni de dépendance framework dans les objets du domaine (domaine isolé).
- Un VO invalide ne doit pas pouvoir exister : valider dans le constructeur, échouer tôt.
- Si la logique tient en getters/setters et CRUD, c'est un signe que DDD est de trop ici.
