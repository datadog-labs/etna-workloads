# Adapted injection for do not leak auto traits in item bounds

Fix: https://github.com/rust-lang/rust/commit/ce9d8678ca9d25c603dfc655a5f955bee4a0a9fe

# Rationale
File: compiler/rustc_next_trait_solver/src/solve/trait_goals.rs, fn consider_auto_trait_candidate.
Removed the loop `for item_bound in cx.item_self_bounds(def_id.into()).skip_binder() { if item_bound.as_trait_clause().is_some_and(|b| b.def_id() == goal.predicate.def_id()) { return Err(NoSolution) } }`
inside the `ty::Alias(.., Opaque)` branch. This re-expresses fix hunk `@@ -174,20 +175,37 @@` which added that loop (don't leak auto traits of opaques if provable via item bounds). Without it, auto-trait leakage causes query cycles in the next solver.
