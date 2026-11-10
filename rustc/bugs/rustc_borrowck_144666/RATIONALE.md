# Adapted injection for Make sure to account for the right item universal regions in borrowck

Fix: https://github.com/rust-lang/rust/commit/98d08ff014840a15244374178e8b9ed02da3d4ca

# Hunk: compiler/rustc_borrowck/src/universal_regions.rs, `for_each_late_bound_region_in_item`
Re-expresses fix hunk `@@ -969,13 +969,28 @@ fn for_each_late_bound_region_in_item`. The fix replaced the `is_fn_like()` check plus
`tcx.late_bound_vars(hir_id)` with a `def_kind` match that, for closures, reads bound vars from the deduced closure signature.
I restored the old code: `if !is_fn_like() { return }` and `late_bound_vars(local_def_id_to_hir_id(mir_def_id))` for all fn-like items, including closures.
