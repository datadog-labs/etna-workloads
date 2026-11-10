# Adapted injection for Report nicer lifetime errors for specialization

Fix: https://github.com/rust-lang/rust/commit/f46eabb9e56fab132ec8171d0e0239f42c986e52

# Re-injection
File: compiler/rustc_hir_analysis/src/impl_wf_check/min_specialization.rs, fn get_impl_args.
The call to translate_args_with_cause (renamed from translate_substs_with_cause) now passes
`&ObligationCause::dummy()` instead of a cause pointing at impl1's span (1.99.1 uses `ObligationCause::misc(impl1_span, impl1_def_id)`).
Re-expresses the fix hunk `@@ -180,8 +180,21 @@ fn get_impl_substs(`, which replaced translate_substs (dummy cause) with
translate_substs_with_cause and a BindingObligation cause; and the
`|_, _| ObligationCause::dummy()` defaults. Result: the E0477 error loses its span/note pointing at the impl bound.
