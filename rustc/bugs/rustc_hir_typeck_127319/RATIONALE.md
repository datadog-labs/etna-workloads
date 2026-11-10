# Adapted injection for Remove a use of `StructuredDiag`, which is incompatible with automatic error tainting and error translations

Fix: https://github.com/rust-lang/rust/commit/0d54fe0d02f24923cc82bbdae786471bfa79d70c

# Rationale
One hunk: compiler/rustc_hir_typeck/src/cast.rs, `CastCheck::report_cast_error`, arm `CastError::SizedUnsizedCast`.

Re-expresses fix hunk `@@ -500,16 +500,12 @@ impl<'a, 'tcx> CastCheck<'tcx>` (`CastError::SizedUnsizedCast`), which replaced
the old `SizedUnsizedCast::new(&fcx.tcx.sess, ...).diagnostic().emit()` (a `StructuredDiag`, built on
`sess.dcx()`, with `downgrade_to_delayed_bug()` if `expr_ty.references_error()`) by `fcx.dcx().emit_err(...)`.
Here the error is created through `fcx.tcx.sess.dcx()` (the untainted handle, as the structured diag did) and downgraded
to a delayed bug when `expr_ty` references an error. The typeck results are therefore not tainted, and const eval
later ICEs (interpret/cast.rs:270) on the ill-typed cast.
