# Adapted injection for Emit a hint for bad call return types due to generic arguments

Fix: https://github.com/rust-lang/rust/commit/a3cf3822d267524e3d9fa45309f2718793f3cf7f

# Rationale
File compiler/rustc_hir_typeck/src/demand.rs, fn `emit_coerce_suggestions`: removed the call
`self.note_wrong_return_ty_due_to_generic_arg(err, expr, expr_ty);` (the helper, renamed from the fix's
`check_wrong_return_type_due_to_generic_arg`, is kept with #[allow(dead_code)]).
Re-expresses fix hunk `@@ -85,6 +85,7 @@` which added `self.check_wrong_return_type_due_to_generic_arg(err, expr, expr_ty);`.
The second hunk (the function definition) is left in place since the function is unused without the call, so the hint is never emitted.
