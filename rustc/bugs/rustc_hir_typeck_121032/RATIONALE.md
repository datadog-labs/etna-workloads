# Adapted injection for Continue reporting remaining errors instead of silently dropping them

Fix: https://github.com/rust-lang/rust/commit/e9cda9b139548ca096f5fb5f9823bee259f267be

# Rationale
File: compiler/rustc_hir_typeck/src/fn_ctxt/checks.rs, function reporting argument-count/type errors (the code after `filter_out_invalid_arguments()`, in report_arg_errors).

Re-expresses the fix hunk `@@ -740,8 +740,9 @@ impl<'a, 'tcx> FnCtxt<'a, 'tcx>`:
`if let Some(reported) = reported && errors.is_empty() { return reported; }` (fixed) vs. the old
`if let Some(reported) = reported { assert!(errors.is_empty()); return reported; }`.
In 1.99.1 the code is `if let Some(err) = fn_call_diag_ctxt.filter_out_invalid_arguments() && fn_call_diag_ctxt.errors.is_empty()`; I restored the old form with the assert, so remaining errors are dropped / ICE when a cyclic-type argument coexists with an arity error.
