# Adapted injection for report_not_const_evaluatable_error to avoid ICEing on ConstKind::Expr

Fix: https://github.com/rust-lang/rust/commit/69a2bd6c044ac4d638f901ff2f5849c6eee3b08e

# Rationale
File: compiler/rustc_trait_selection/src/error_reporting/traits/fulfillment_errors.rs, fn report_not_const_evaluatable_error
(was type_err_ctxt_ext.rs upstream). Removed the `ty::ConstKind::Expr(_)` arm that emitted
"unconstrained generic constant `{ct}`". This re-expresses the fix hunk
`@@ -3525,20 +3525,30 @@` which added `ty::ConstKind::Expr(_) => { ... struct_span_err(span, format!("unconstrained generic constant `{ct}`")) }`.
Without it, Expr consts fall to the `_ => bug!(...)` arm, i.e. the original ICE.
