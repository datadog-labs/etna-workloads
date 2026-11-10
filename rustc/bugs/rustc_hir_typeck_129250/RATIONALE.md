# Adapted injection for Do not ICE on non-ADT rcvr type when looking for crate version collision

Fix: https://github.com/rust-lang/rust/commit/00c435d9b37540d16489862446d934e98e58dfb1

# Rationale
File: compiler/rustc_hir_typeck/src/method/suggest.rs, fn `suggest_traits_to_import` (the `SelfSource::QPath(ty)` block calling `detect_and_explain_multiple_crate_versions_of_trait_item`).

Re-expresses fix hunk `@@ -3689,8 +3689,7 @@` / `-3700,7 +3699,8`: the fix replaced
`let hir::QPath::Resolved(_, path) = path && let Some(def_id) = path.res.opt_def_id()` with `Resolved(..)`, and
`let rcvr_ty = self.tcx.type_of(def_id).instantiate_identity();` with `self.node_ty_opt(ty.hir_id)`.
I restored the old def_id + `type_of(def_id).instantiate_identity()` (wrapped in Some, since 1.99.1's callee already takes Option, i.e. the other hunks are already in place). For `T::try_from()` with `T` a type parameter, `type_of` on a type-param def_id ICEs.
