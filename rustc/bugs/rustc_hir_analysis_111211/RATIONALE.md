# Adapted injection for Don't compute trait super bounds unless they're positive

Fix: https://github.com/rust-lang/rust/commit/930eece9d34b67533cf3d27c06253e806a5add0f

# Rationale
File: compiler/rustc_hir_analysis/src/collect/clauses_of.rs, fn implied_clauses_with_filter (was implied_predicates_with_filter in predicates_of.rs).
In the `PredicateFilter::SelfOnly` loop, removed `&& bound.polarity == ty::PredicatePolarity::Positive`, so negative supertraits (`trait A: !B`) are also forced via `explicit_super_clauses_of`, causing a cycle error for `trait A: !B {}  trait B: !A {}`.
Re-expresses fix hunk `@@ -657,14 +657,15 @@ pub(super) fn implied_predicates_with_filter(` which added `&& bound.polarity == ty::ImplPolarity::Positive`.
