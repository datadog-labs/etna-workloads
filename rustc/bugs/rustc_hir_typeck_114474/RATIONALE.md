# Adapted injection for Detect missing `;` that parses as function call

Fix: https://github.com/rust-lang/rust/commit/8ecb486add8eb58dedc6fa88f2fe42e8941335c3

# callee.rs, FnCtxt::report_invalid_callee (the error path in compiler/rustc_hir_typeck/src/callee.rs)
Re-expresses both hunks of fix.diff (`@@ -645,18 +645,6 @@` and `@@ -668,6 +656,23 @@`):
the multiline-semicolon suggestion is moved back into the `ExprKind::Call(inner_callee, _)` match arm
(only fires when callee is itself a call), uses `is_multiline(call_expr.span)` without the
`with_lo(callee_expr.span.hi())` / ctxt checks, drops the `!maybe_suggest_bad_array_definition` gating,
and restores the old message "consider using a semicolon here" (instead of "... to finish the statement").
