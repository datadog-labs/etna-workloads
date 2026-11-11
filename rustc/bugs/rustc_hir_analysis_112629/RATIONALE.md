# Adapted injection for Make associated type bounds in supertrait position implied

Fix: https://github.com/rust-lang/rust/commit/858a861fff3c054f5eccb74c22d061f1765e9cbd

# Rationale
File: compiler/rustc_hir_analysis/src/collect/clauses_of.rs, fn `explicit_implied_clauses_of` (1.99.1 successor of `implied_predicates_of`).
For non-trait-alias traits it now uses `PredicateFilter::SelfOnly` instead of `PredicateFilter::SelfAndAssociatedTypeBounds`, so associated type bounds in supertrait position (`trait Sub: Super<A: B>`) are no longer implied.
Re-expresses hunk `@@ -564,11 +569,15 @@ pub(super) fn implied_predicates_of` where the fix replaced `tcx.super_predicates_of(trait_def_id)` (SelfOnly) with `implied_predicates_with_filter(..., PredicateFilter::SelfAndAssociatedTypeBounds)`.
