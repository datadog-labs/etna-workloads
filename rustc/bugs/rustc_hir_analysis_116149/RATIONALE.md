# Adapted injection for Anonymize binders for refining_impl_trait check

Fix: https://github.com/rust-lang/rust/commit/305524d1d655f744e739f45850bc6f74918ac0c9

# Rationale
File: compiler/rustc_hir_analysis/src/check/compare_impl_item/refine.rs, fn check_refining_return_position_impl_trait_in_trait.
Re-expresses hunk `@@ -176,9 +176,13 @@`: the fix replaced `FxIndexSet::from_iter(trait_bounds)` with
`FxIndexSet::from_iter(trait_bounds.fold_with(&mut Anonymize { tcx }))` plus `impl_bounds.fold_with(&mut Anonymize { tcx })`.
I removed the anonymizing folds (back to `FxIndexSet::from_iter(trait_bounds)`, impl_bounds unfolded), so named-bound-var DefIds differ and refinement is falsely reported. The Anonymize struct is left (now unused, dead-code warning), matching the other hunks being no-ops in the buggy parent.
