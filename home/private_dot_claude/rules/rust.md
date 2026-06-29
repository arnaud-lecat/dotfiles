---
description: Conventions Rust
paths: ["**/*.rs", "**/Cargo.toml"]
---

# Rust

- `cargo clippy` et `cargo fmt` doivent passer sans warning (CI en `-D warnings`).
- Pas de `unwrap()`/`expect()`/`panic!` dans le code de lib : propager avec `Result` + `?`.
- Erreurs : `thiserror` pour les libs, `anyhow` pour les binaires/applications.
- Emprunter (`&`) plutôt que `clone()` ; ne cloner que quand c'est nécessaire et assumé.
- Dériver les traits utiles (`Debug`, `Clone`, `PartialEq`…) plutôt que de les implémenter à la main.
- `unsafe` uniquement si justifié, avec un commentaire `// SAFETY:` expliquant l'invariant.
