# Adapted injection for enable eager param_env norm in new solver

Fix: https://github.com/rust-lang/rust/commit/711ec67c1c6d9326a04127506d71005a3ca9bff7

# Rationale
One hunk: `compiler/rustc_trait_selection/src/traits/mod.rs`, `do_normalize_clauses` (renamed from `do_normalize_predicates` in 1.99.1).
Re-adds the early return that the fix removed:
fix hunk `@@ -257,12 +257,6 @@ fn do_normalize_predicates<'tcx>(` removed
`if tcx.next_trait_solver_globally() { return Ok(predicates); }` ("param env normalization remains lazy in the next solver").
Here it returns `clauses` unnormalized under the next solver, so param-env normalization is lazy again.
