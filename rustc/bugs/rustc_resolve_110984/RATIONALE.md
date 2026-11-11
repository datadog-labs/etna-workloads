# Adapted injection for Do not force anonymous lifetimes in consts to be static.

Fix: https://github.com/rust-lang/rust/commit/63028ac3a1cdad56e4a61b8fcb260456efc2b71e

# Rationale
File compiler/rustc_resolve/src/late.rs, fn resolve_anon_const_manual: the lifetime rib wrapping anon-const resolution
changed from `LifetimeRibKind::elided(LifetimeRes::Infer)` back to `LifetimeRes::Static`.
In 1.99.1 the two fix hunks (`visit_anon_const` @@ -656 and the `ExprKind::Repeat` @@ -4130, both
`Elided(LifetimeRes::Static)` -> `Elided(LifetimeRes::Infer)`) were consolidated into this single function, so
one edit re-expresses both: elided lifetimes in anon consts (incl. repeat lengths) are forced to 'static again.
