# Adapted injection for Use placeholders to prevent using inferred RPITIT types to imply their own WF-ness

Fix: https://github.com/rust-lang/rust/commit/b5a904a9d450c2afbefcc0c95974f3396e73d487

# Rationale
All changes are in `collect_return_position_impl_trait_in_trait_tys` (compiler/rustc_hir_analysis/src/check/compare_impl_item.rs).

1. Removed the placeholder mapping (`create_next_universe`, `mapping`, `type_mapper`) and the `.map(|ty| ty.fold_with(&mut type_mapper))` on `wf_tys`. Re-expresses hunk `@@ -725,12 +726,68 @@`, which added the placeholders and folded `wf_tys` with them. Without it, the RPITIT hidden-type infer vars imply their own WF-ness again.
2. Removed the loop registering `ClauseKind::WellFormed(ty)` for each collected hidden type, and moved `let collected_types = collector.types;` back to after `select_all_or_error`/error reporting. Re-expresses hunk `@@ -787,6 +844,20 @@` (added the WF obligations) and `@@ -795,8 +866,6 @@` (moved `collected_types`).
