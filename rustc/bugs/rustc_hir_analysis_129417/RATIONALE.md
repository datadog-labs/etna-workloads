# Adapted injection for Don't trigger refinement lint if predicates reference errors

Fix: https://github.com/rust-lang/rust/commit/8eb15586c6472077916730ca994e7bd5def09220

# Rationale
File: compiler/rustc_hir_analysis/src/check/compare_impl_item/refine.rs, fn check_refining_return_position_impl_trait_in_trait.
Removed the early return `if trait_bounds.references_error() || impl_bounds.references_error() { return; }`,
re-expressing fix hunk `@@ -177,6 +178,10 @@ pub(super) fn check_refining_return_position_impl_trait_in_trait`. The import hunk (TypeVisitableExt) is unneeded on 1.99.1 (already imported/unused concern is none).
