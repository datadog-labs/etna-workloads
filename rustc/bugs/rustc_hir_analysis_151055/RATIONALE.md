# Adapted injection for Emit error instead of delayed bug when meeting mismatch type for const array

Fix: https://github.com/rust-lang/rust/commit/d616e6cb189c762789a8179cb00e065fcc7f9992

# Hunk: compiler/rustc_hir_analysis/src/hir_ty_lowering/mod.rs, `lower_const_arg_array`
Fix hunk `@@ -2415,11 +2415,10 @@` replaced `Const::new_error_with_message(tcx, array_expr.span, "const array must have an array type")` with `span_err(... "expected `{}`, found const array")` + `Const::new_error`.
In 1.99.1 the code is the `_ =>` arm of the `match ty.kind()`; I restored the delayed-bug-style `new_error_with_message` there (no user-facing error emitted).
