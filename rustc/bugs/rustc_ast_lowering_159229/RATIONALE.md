# Adapted injection for Reject invalid direct_const_arg nested owners

Fix: https://github.com/rust-lang/rust/commit/e94c0e6e9ebdfb41ddcdb93fce4a7fc37453cdde

# Rationale
Hunk: compiler/rustc_ast_lowering/src/lib.rs, `emit_bad_direct_const_arg` (introduced by the fix's hunk `@@ -1774,6 +1770,22 @@`).
The fix makes the error fatal (`struct_span_fatal`) when `expr::WillCreateDefIdsVisitor.visit_expr(expr).is_break()`, i.e. the invalid direct_const_arg contains nested owners (closures/items). I removed that check and always emit a non-fatal `struct_span_err`, matching the pre-fix behaviour (plain `struct_span_err(...).emit()` in the `TyKind::DirectConstArg` / `ExprKind::DirectConstArg` arms). Nested owners in the discarded expression then are never lowered/defined, leading to an ICE/mismatch.
The expr.rs hunk already matched 1.99.1's helper call, so it was left unchanged.
