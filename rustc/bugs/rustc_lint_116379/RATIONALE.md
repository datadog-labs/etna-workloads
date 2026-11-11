# Adapted injection for non_lifetime_binders: fix ICE in lint opaque-hidden-inferred-bound

Fix: https://github.com/rust-lang/rust/commit/3f0a327fbbb28c90fb33425aa8871d0c0d4a9c48

# Rationale
File: compiler/rustc_lint/src/opaque_hidden_inferred_bound.rs, `check_ty` (OpaqueHiddenInferredBound).

Re-expresses fix hunk `@@ -79,9 +77,7 @@ impl<'tcx> LateLintPass<'tcx> for OpaqueHiddenInferredBound`:
`-let predicate = cx.tcx.liberate_late_bound_regions(def_id, pred.kind());`
`+let predicate = infcx.instantiate_binder_with_placeholders(pred.kind());`
In 1.99.1 the code uses `infcx.enter_forall(pred.kind(), |predicate| ...)`; I restored the old
`liberate_late_bound_regions(def_id, pred.kind())`, then run the (unchanged) body as an immediately-called closure.
liberate_late_bound_regions ICEs ("unexpected bound ty in binder") on type binders (`for<T>`).
The doc-comment hunks of the fix were not reverted (irrelevant to behaviour).
