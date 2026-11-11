# Adapted injection for Fix ICE in normalization during closure capture analysis

Fix: https://github.com/rust-lang/rust/commit/ac448c987d2ed4b8ef50bb2f5422c093c1e161a5

# Rationale
File: compiler/rustc_middle/src/ty/util.rs, `Ty::has_significant_drop` (tail, query path).
Re-expresses fix hunk `@@ -1394,8 +1394,10 @@ impl<'tcx> Ty<'tcx>`: the fix replaced
`tcx.normalize_erasing_regions(typing_env, query_ty)` with `try_normalize_erasing_regions(...).map(...).unwrap_or(true)`.
I restored the infallible `normalize_erasing_regions` call, which ICEs when normalization fails.
