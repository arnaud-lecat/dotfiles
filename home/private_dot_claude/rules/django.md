---
description: Conventions Django
paths:
  [
    "**/models.py",
    "**/views.py",
    "**/urls.py",
    "**/admin.py",
    "**/serializers.py",
    "**/settings.py",
    "**/manage.py",
    "**/apps.py",
    "**/forms.py",
  ]
---

# Django

- Logique métier hors des vues : vues fines, métier dans des services ou des méthodes de modèle/manager.
- ORM maîtrisé : `select_related`/`prefetch_related` contre le N+1 ; jamais de requête dans une boucle.
- Managers/QuerySets pour les requêtes réutilisables ; les QuerySets sont paresseux, les garder composables.
- Migrations : ne jamais éditer une migration déjà appliquée ; un changement logique par migration ; relire le SQL généré.
- Settings découpés par environnement ; secrets via variables d'env (jamais en dur, jamais commités).
- S'appuyer sur l'existant : auth, forms, validators, `messages` plutôt que de réinventer.
- API : Django REST Framework — serializers pour la validation, viewsets ; pas de métier dans les serializers.
- `USE_TZ = True` ; toujours des datetimes aware (`django.utils.timezone`).
- Tests : `pytest-django`, factories (factory_boy) plutôt que fixtures figées.
