# Adapted injection for Consider param-env candidates, too

Fix: https://github.com/rust-lang/rust/commit/e425d85518b4e3c2dc6edfccab638db26380198a

# Rationale
File: compiler/rustc_trait_selection/src/traits/outlives_for_liveness.rs, `FreeRegionsVisitor::visit_ty` (alias case).
The fix hunk `@@ -622,6 +624,7 @@ ... let param_env = ...; .chain(param_env.caller_bounds().iter().filter_map(... extract_verify_if_eq ...))`
made the liveness computation also consider param-env outlives clauses (e.g. `for<'a> T::Assoc<'a>: 'static`), not just item bounds.
In 1.99.1 that logic moved here; I removed the `for clause in param_env.caller_bounds()` loop (calling `live_args_for_outlives_clause`), so only item bounds are considered again.
