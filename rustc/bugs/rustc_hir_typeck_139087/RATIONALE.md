# Adapted injection for thread through a `HirId` to emit lints in the right place

Fix: https://github.com/rust-lang/rust/commit/a7590138a73e246a0b219d8ae806cf7753febf1a

# Hunks changed
1. compiler/rustc_hir_typeck/src/fn_ctxt/checks.rs, `check_expr_lit` (Float literal arm):
   `self.next_float_var(lit.span, Some(lint_id))` -> `self.next_float_var(lit.span, None)`.
   Re-expresses fix hunk `@@ -765,7 +766,7 @@ ... opt_ty.unwrap_or_else(|| self.next_float_var(lit.span, Some(lint_id)))`.
   The literal's HirId is no longer threaded, so the FCW falls back to `CRATE_HIR_ID` and can't be allowed/expected at the literal.
2. compiler/rustc_lint_defs/src/builtin.rs, `declare_lint_pass!`: removed `FLOAT_LITERAL_F32_FALLBACK,`.
   Re-expresses fix hunk `@@ -47,6 +47,7 @@ ... +        FLOAT_LITERAL_F32_FALLBACK,` (lint missing from the pass, so not in the future_incompatible group note).
