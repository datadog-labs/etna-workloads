# Adapted injection for Consolidate type system const evaluation under `traits::evaluate_const`

Fix: https://github.com/rust-lang/rust/commit/bea0148ac62758a99dcc2ac2cc2efedacb8881bf

# Rationale
One hunk: `compiler/rustc_trait_selection/src/traits/mod.rs`, `try_evaluate_const`, `Ok(Err(_))` arm of `const_eval_resolve_for_typeck`.

The fix's hunk `@@ -474,6 +487,198 @@ pub fn normalize_param_env_or_error` adds `evaluate_const`/`try_evaluate_const`.
It also adds the `Ok(Err(_)) => delayed_bug("Type system constant with non valtree'able type evaluated but no error emitted"); Err(InvalidConstParamTy(e))` arm.
Before the fix, type-system const evaluation had no recoverable error for a non-valtree-able const type (e.g. `fn()` params, #118545 and #128232). It hit a hard ICE instead.
1.99.1 already contains the consolidated code, and the old paths (`normalize_internal`, `infcx.const_eval_resolve`) no longer exist.
So I changed that arm to `span_bug!`, which brings back the ICE on non-valtree-able constants.
Other hunks of the fix are not reverted.
