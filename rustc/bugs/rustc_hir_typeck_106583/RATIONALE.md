# Adapted injection for Suggest coercion of `Result` using `?`

Fix: https://github.com/rust-lang/rust/commit/e477cf9475540bf7f5f71940b29fc065cb988982

# Rationale
The fix added the "implicit conversion that `?` does" suggestion for mismatched `Result` error types
(hunks `@@ -1565`, `@@ -1584`, `@@ -1625` in coercion.rs: calls to and definition of `note_result_coercion`).
In 1.99.1 that logic lives in `suggest_coercing_result_via_try_operator` (fn_ctxt/suggestions.rs), called from
`emit_type_mismatch_suggestions` in demand.rs. I removed that call (demand.rs, the `|| self.suggest_coercing_result_via_try_operator(...)` line),
restoring the pre-fix behaviour of no suggestion, and added `#[allow(dead_code)]` on the now-unused function.
