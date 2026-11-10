# Adapted injection for Add projection obligations when comparing impl too

Fix: https://github.com/rust-lang/rust/commit/31032ecb1550a402a726e9c244f6a716b214cc9d

# Rationale
Fix hunk: compiler/rustc_hir_analysis/src/check/compare_impl_item.rs `@@ -342,9 +342,16 @@ fn compare_method_predicate_entailment`
added `ty::ClauseKind::Projection(..)` to the implied-bound obligations registered with the ocx
("We need to register Projection obligations too, because we may end up with an implied `X::Item: 'a`,
which gets desugared into `X::Item = ?0`, `?0: 'a`"). That loop no longer exists in 1.99.1; implied bounds
are now computed in `compute_implied_outlives_bounds_inner`
(compiler/rustc_trait_selection/src/traits/implied_outlives_bounds.rs).

Change: there, the obligation predicate from `wf::unnormalized_obligations` is no longer passed through
`ocx.deeply_normalize(..)` (which processes the projection obligations that normalization of the alias
introduces); `let pred = obligation.predicate;` is used instead. So projection obligations/alias
normalization are dropped when deriving implied outlives bounds, and `<D as Data>::Elem: 'a` is
no longer resolved to the constrained type -> the same symptom (the test's E0309) as the original bug.
This is an approximate re-expression, since the original code site was refactored away.
