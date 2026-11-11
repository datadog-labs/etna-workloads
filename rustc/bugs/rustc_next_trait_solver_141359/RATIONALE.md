# Adapted injection for Fix FnOnce impl for AsyncFn/AsyncFnMut closures in new solver

Fix: https://github.com/rust-lang/rust/commit/e0f80558716372902b2eda1e43ab2e169bfb3669

# Hunk
File: compiler/rustc_next_trait_solver/src/solve/assembly/structural_traits.rs, fn extract_tupled_inputs_and_output_from_callable, `ty::CoroutineClosure` arm.
Changed `if goal_kind != ty::ClosureKind::FnOnce && args.has_self_borrows()` to use `kind != ...` (the closure's own kind) instead of the goal kind.
Re-expresses fix hunk `@@ -327,7 +327,7 @@`: `-if closure_kind != ty::ClosureKind::FnOnce && args.has_self_borrows()` / `+if goal_kind != ...`. (Variable is named `kind` in 1.99.1.) An AsyncFnMut closure with self borrows then wrongly fails the FnOnce goal in the new solver.
