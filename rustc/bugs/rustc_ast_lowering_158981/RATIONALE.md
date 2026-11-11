# Adapted injection for Fix where-bound suggestion for legacy const generics

Fix: https://github.com/rust-lang/rust/commit/4882893863fabec457aeea337eb654d479c96cca

# Rationale
1. compiler/rustc_ast_lowering/src/expr.rs (lower_legacy_const_generics): `create_def(.., DefKind::AnonConst, arg.span)` reverted to `f.span`.
   Re-expresses hunk `@@ -597,7 +597,7 @@` (`-create_def(... f.span)` / `+... arg.span`). The anon const's span is again the whole callee, so the suggestion snippet is wrong.
2. compiler/rustc_trait_selection/.../fulfillment_errors.rs (unconstrained generic constant suggestion): removed the `expr_needs_parens` branch producing `[(); ({snippet}) as usize]:`, always emitting `[(); {snippet} as usize]:` and dropped the import.
   Re-expresses hunk `@@ -3798,13 +3798,24 @@` (the `expr_needs_parens(local_body.value)` branch) and the import hunk `@@ -16,7 +16,7 @@`.
