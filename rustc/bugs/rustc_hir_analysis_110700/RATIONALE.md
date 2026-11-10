# Adapted injection for Don't infer fn return type to return itself

Fix: https://github.com/rust-lang/rust/commit/c8874e24458e7ba88fad7969562a45c951d002a8

# Rationale
File: compiler/rustc_hir_analysis/src/collect.rs, fn `recover_infer_ret_ty` (was `infer_return_ty_for_fn_sig`).
The fix hunk `@@ -1181,9 +1179,20 @@` replaced `ty::Binder::dummy(fn_sig)` (leaking the inferred return type) with an error return type unless `should_recover` (type nameable/suggestable). In 1.99.1 this is `recovered_ret_ty.unwrap_or_else(|| Ty::new_error(tcx, guar))`. I changed it to `recovered_ret_ty.unwrap_or(ret_ty)`, so the non-nameable inferred type (e.g. fn returning itself) leaks into the signature again; `let guar = diag.emit()` became `diag.emit()` accordingly (hunk `-diag.emit(); +let guar = diag.emit();`).
