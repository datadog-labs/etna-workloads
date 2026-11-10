# Adapted injection for Use trait definition cycle detection for trait alias definitions, too

Fix: https://github.com/rust-lang/rust/commit/37f2998c6e7eeac6a5e4f1aaec9ab353bb2f7b0b

# Rationale
File `compiler/rustc_hir_analysis/src/collect/clauses_of.rs`, fn `implied_clauses_with_filter` (the 1.99.1 successor of `implied_predicates_with_filter` in predicates_of.rs).
Fix hunk `@@ -653,7 +653,7 @@ pub(super) fn implied_predicates_with_filter`:
`-PredicateFilter::SelfAndAssociatedTypeBounds => {` / `+PredicateFilter::All | PredicateFilter::SelfAndAssociatedTypeBounds => {`.
I removed `PredicateFilter::All |` from the cycle-detection match arm again. Trait aliases use `All`, so they no longer eagerly walk their supertraits' implied clauses. Cycles then go undetected and normalization recurses infinitely.
