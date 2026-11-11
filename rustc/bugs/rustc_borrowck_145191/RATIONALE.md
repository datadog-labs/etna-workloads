# Adapted injection for `suggest_borrow_generic_arg`: use the correct generic args

Fix: https://github.com/rust-lang/rust/commit/a70a312f172c9d74f0b01bd2a6e1d9d77bcf6771

All changes in compiler/rustc_borrowck/src/diagnostics/conflict_errors.rs, reverting the fix's 4 hunks:
- `@@ -410,18 +410,18 @@` (report_use_of_moved_or_uninitialized): restored `call_id` in the tuple (`Some(parent_expr.hir_id)` for method calls, `Some(call.hir_id)` for calls, `None` otherwise).
- `@@ -459,11 +459,12 @@`: caller again computes `generic_args = call_id.and_then(|id| typeck.node_args_opt(id))` and passes it, instead of passing typeck/call_expr.
- `@@ -627,8 +628,9 @@` suggest_borrow_generic_arg signature: takes `generic_args` again instead of `typeck, call_expr`.
- `@@ -639,6 +641,19 @@`: removed the `match call_expr.kind` that took args from the callee's FnDef type; for `run.clone()(..)` the callee node's args are clone's, giving wrong args (ICE/wrong suggestion).
