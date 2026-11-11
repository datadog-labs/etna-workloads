# Adapted injection for Inside eager ty aliases on unresolved assoc tys suggest fully qualifying instead of restricting their self ty

Fix: https://github.com/rust-lang/rust/commit/3c8b1085127b64de64cb6d880b59b55c1d6fc8e9

# Rationale
File: compiler/rustc_hir_analysis/src/hir_ty_lowering/errors.rs, fn complain_about_assoc_item_not_found (the "similar in other trait" path).

Re-expresses the hunk `@@ -251,27 +251,44 @@` of hir_ty_lowering/errors.rs in fix.diff, which added
`if let DefKind::TyAlias = tcx.def_kind(item_def_id) && !tcx.type_alias_is_lazy(item_def_id) { err.sugg = Some(SimilarInOtherTraitQPath{..}) } else { ...suggest_constraining_type_param... }`.
I removed that branch (the 1.99.1 form checks `!tcx.type_alias_is_checked`) and kept only the else-body. Inside eager type aliases the compiler once again suggests restricting the type parameter, which is the pre-fix behaviour. The other fix hunks (new ftl and enum variant, ty_param_span plumbing) are left in place. They are now dead code.
