# Adapted injection for When computing opaque types in the next solver, take an initial pass pre-fallback where we equate hidden types but do not report errors

Fix: https://github.com/rust-lang/rust/commit/db3c9b640e8adabbee20e212f9ebb473513bad8b

# Rationale
One hunk: compiler/rustc_hir_typeck/src/lib.rs, `typeck_with_inspect`. Removed the pre-fallback call
`if fcx.next_trait_solver() { fcx.try_handle_opaque_type_uses_next(); }` placed before `fcx.type_inference_fallback();`.
Re-expresses fix hunk `@@ -219,6 +219,12 @@ fn typeck_with_inspect<'tcx>(` which added that call ("We need to handle opaque types before emitting ambiguity errors...").
The opaque_types.rs hunks of the fix are already present in 1.99.1 (try_handle_opaque_type_uses_next exists); only the call site is removed, so hidden types are no longer equated before fallback.
