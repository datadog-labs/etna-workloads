# Adapted injection for Leak check in impossible_predicates to avoid monomorphizing impossible instances

Fix: https://github.com/rust-lang/rust/commit/377dbc96a6d5b7d22b75d4bd98fd00d9e1bb194e

# Rationale
File: compiler/rustc_trait_selection/src/traits/mod.rs, fn `impossible_clauses` (successor of `impossible_predicates`).
Change: `.with_next_trait_solver(true)` -> `.with_next_trait_solver(false)`.

Fix hunk `@@ -714,9 +714,18 @@ pub fn impossible_predicates` added a leak check (`!infcx.next_trait_solver() && infcx.leak_check(ROOT, None).is_err()` -> impossible) because the old solver did not leak-check higher-ranked mismatches; the new solver already does. In 1.99.1 the function always uses the new solver (which leak-checks), so the pre-fix behaviour (old solver, no leak check, impossible instances treated as possible and monomorphized) is restored by selecting the old solver.
