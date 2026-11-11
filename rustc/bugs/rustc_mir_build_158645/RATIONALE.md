# Adapted injection for Improve ICE diag for splatted FnPtrs

Fix: https://github.com/rust-lang/rust/commit/baccb0c7d67748df3f27ff5359cec84a47116838

# Rationale
One hunk: compiler/rustc_mir_build/src/thir/cx/expr.rs, `convert_splatted_callee`, `SplattedDef::FnPtr` arm.
Re-expresses fix hunk `@@ -1225,26 +1225,50 @@ impl<'tcx> ThirBuildCx<'tcx>`, where the fixed FnPtr branch gets the type via
`self.typeck_results.expr_ty_adjusted(expr)` and then does `if !fn_ty.is_fn() { span_bug!(.. "splatted FnPtr side-tables are not yet implemented") }`.
The buggy parent had no proper FnPtr handling and ICEd. In 1.99.1 the FnPtr type is recorded in `SplattedDef::FnPtr`. The injected bug ignores it and re-derives the callee type from the call expression's adjusted type (`expr_ty_adjusted(call_expr)`), which is the call's result type, not a fn type. So the `is_fn` check ICEs for valid splatted FnPtr calls.
