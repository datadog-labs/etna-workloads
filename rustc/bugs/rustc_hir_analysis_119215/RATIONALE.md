# Adapted injection for Emits error if has bound regions

Fix: https://github.com/rust-lang/rust/commit/4830325a142952b69cf31c128d755e87ad5817d8

File: compiler/rustc_hir_analysis/src/check/entry.rs, fn check_main_fn_ty.
Re-expresses fix hunk `@@ -124,7 +124,10 @@ fn check_main_fn_ty`: the fix replaced `return_ty.skip_binder()` with
`let Some(return_ty) = return_ty.no_bound_vars() else { emit MainFunctionReturnTypeGeneric; return }`.
I restored `let return_ty = return_ty.skip_binder();` (no E0131 error when return type has bound vars).
