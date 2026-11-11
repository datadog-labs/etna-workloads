# Adapted injection for Emit error when there is an infer lifetime in user-specified args in delegation

Fix: https://github.com/rust-lang/rust/commit/a10c598e864e7c837486b44362434f8a23bd0d4e

# Rationale
Only hunk changed: compiler/rustc_hir_analysis/src/collect.rs, `ItemCtxt::re_infer` (the `else` branch that builds the illegal-lifetime region).
Re-expresses the fix hunk `@@ -335,8 +353,15 @@ impl<'tcx> HirTyLowerer<'tcx> for ItemCtxt<'tcx>`: removes
`if self.lowering_delegation_segment { emit_err(ElidedLifetimesAreNotAllowedInDelegations { span }) }`
and restores the old message "unelided lifetime in signature" (fix changed it to "inferred lifetime in signature").
So an inferred lifetime in user-specified delegation args no longer gets an error. The import of the error type was dropped and an `#[allow(dead_code)]` added on the now-unread field to keep the build warning-free.
The rest of the fix (query, new_for_delegation) is already in 1.99.1 and was left alone.
