# Adapted injection for Fix bound var resolution for trait aliases

Fix: https://github.com/rust-lang/rust/commit/7c5ea7ffd648cb1170510a7b50b0294a30891ffd

File: compiler/rustc_hir_analysis/src/collect/resolve_bound_vars.rs
Fix hunks: `@@ -1695 ... | DefKind::Trait | DefKind::TraitAlias` (eligible container kinds) and
`@@ -1865 ... && let DefKind::Trait | DefKind::TraitAlias = ...` (RTN supertrait_hrtb_vars).
1.99.1 refactored this into `eligible_container`; I removed `DefKind::TraitAlias` from its
Enum/Struct/Trait/TyAlias/Union arm (moved to the None arm), and in the RTN branch of
visit_segment_args restored `def_kind(container_def_id) == DefKind::Trait`.
