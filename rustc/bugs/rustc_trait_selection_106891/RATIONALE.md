# Adapted injection for Tweak "borrow closure argument" suggestion

Fix: https://github.com/rust-lang/rust/commit/33e11a3b2e2f2ee68fb2cb72e20f84c50c4c15cb

# Rationale
File: compiler/rustc_trait_selection/src/error_reporting/traits/suggestions.rs, fn `hint_missing_borrow` (moved from error_reporting/suggestions.rs in 1.99.1).

One hunk: the type comparison `infcx.can_eq(param_env, found_ty, expected_ty)` is replaced by `found_ty == expected_ty`; the `param_env` param is renamed `_param_env` (now unused).
Re-expresses the fix hunk `@@ -3785,21 +3789,34 @@ fn hint_missing_borrow`:
`-        if found_ty == expected_ty {` / `+        if infcx.can_eq(param_env, found_ty, expected_ty).is_ok() {`
With strict equality, `{integer}` vs `i32` (issue #45727) no longer matches, so the "consider borrowing the argument" suggestion is missing.
The other fix hunks (verbose suggestions, span handling) were already restructured in 1.99.1 and left unchanged.
