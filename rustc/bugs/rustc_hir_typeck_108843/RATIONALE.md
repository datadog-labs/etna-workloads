# Adapted injection for Instantiate instead of erasing binder when probing param methods

Fix: https://github.com/rust-lang/rust/commit/b7a5f3a41c6613033f0e6be9307c40e3174a9381

# Hunk: compiler/rustc_hir_typeck/src/method/probe.rs, `consider_probe` (ObjectCandidate | WhereClauseCandidate arm)
Replaces `instantiate_binder_with_fresh_vars(...)` with `tcx.instantiate_bound_regions_with_erased(poly_trait_ref)`.
Re-expresses fix hunks `@@ -842,18 +850,15 @@ ... assemble_inherent_candidates_from_param` (`erase_late_bound_regions(poly_trait_ref)` -> `instantiate_binder_with_fresh_vars`) and `@@ -963,7 +968,11 @@` (same change). In 1.99.1 the candidate stores the poly trait ref and instantiation happens in consider_probe, so the erase is restored there.
Effect: non-lifetime bound var `for<T> Bar<T>` is not instantiated -> ICE "unexpected bound ty in binder".
