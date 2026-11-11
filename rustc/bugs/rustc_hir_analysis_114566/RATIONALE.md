# Adapted injection for Store the laziness of type aliases in the DefKind

Fix: https://github.com/rust-lang/rust/commit/5468336d6b11a56addc589cd24107915e3ba0d66

# Re-injection
In 1.99.1 `DefKind::TyAlias` no longer carries `lazy`; the per-definition laziness is the `type_alias_is_checked` query (encoded in metadata).
Changed: `compiler/rustc_hir_analysis/src/hir_ty_lowering/mod.rs`, `lower_path_segment`:
`&& tcx.type_alias_is_checked(def_id)` -> `&& (tcx.features().checked_type_aliases() || tcx.type_alias_is_checked(def_id))`.
Re-expresses fix hunk `@@ -907,19 +907,21 @@ astconv/mod.rs` (`-&& (ty.skip_binder().has_opaque_types() || self.tcx().features().lazy_type_alias)` / `+if let DefKind::TyAlias { lazy } = ...  && (lazy || ...)`): the bug consults the *current* crate's feature flag instead of the alias's own (defining-crate) laziness, so eager aliases from external crates become weak aliases (issue #114468).
