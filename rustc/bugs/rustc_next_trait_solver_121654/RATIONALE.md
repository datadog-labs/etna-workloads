# Adapted injection for Support `{async closure}: Fn` in new solver

Fix: https://github.com/rust-lang/rust/commit/a6727bad88c45ef05617731aaf42a370e7dcf5e3

# Rationale
File: compiler/rustc_next_trait_solver/src/solve/assembly/structural_traits.rs, fn extract_tupled_inputs_and_output_from_callable
(moved from rustc_trait_selection in 1.99.1).
Fix hunk `@@ -281,7 +281,79 @@` replaced `ty::CoroutineClosure(..) => Err(NoSolution)` with the full
CoroutineClosure handling. I restored the old `ty::CoroutineClosure(..) => Err(NoSolution),`, so under the
new solver `{async closure}: Fn*` (including FnOnce) no longer holds.
