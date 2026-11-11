# Adapted injection for Don't fire OPAQUE_HIDDEN_INFERRED_BOUND on sized return of AFIT

Fix: https://github.com/rust-lang/rust/commit/2aa746913bda5c52b3efeefb756e13c72618f793

# Rationale
File: compiler/rustc_lint/src/opaque_hidden_inferred_bound.rs, `OpaqueHiddenInferredBound::check_ty`.
Removed the block `// HACK: `async fn() -> Self` in traits is "ok"...` (`if let ty::Param(param_ty) = *proj_term.kind() && param_ty.name == kw::SelfUpper && matches!(opaque.origin, AsyncFn{in_trait_or_impl: Some(RpitContext::Trait),..}) { return; }`) and the now-unused `kw` import.
This re-expresses the fix hunks `@@ -96,6 +96,17 @@ impl<'tcx> LateLintPass<'tcx> for OpaqueHiddenInferredBound` (added the HACK skip) and `@@ -4,7 +4,7 @@` (import of `kw`).
