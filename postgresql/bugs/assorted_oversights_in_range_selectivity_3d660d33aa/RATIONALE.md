# Rationale

File: src/backend/utils/adt/rangetypes_selfuncs.c

1. `calc_hist_selectivity()`: swapped the `true`/`false` (equal-bounds) argument to `calc_hist_selectivity_scalar` for `>` and `>=`. This is the reverse of the fix hunk at ~line 443 of fix_impl.patch. `>` and `>=` now count the wrong side of the boundary.
2. `calc_rangesel()`, empty-constant switch: removed the `OID_RANGE_LESS_OP` (0.0) and `OID_RANGE_GREATER_OP` (1 - empty_frac) cases. `>=` is grouped back with `<=`/`<@` as `empty_frac`. This is the reverse of the fix hunk at ~line 270. `<` and `>` with an empty constant now hit the "unexpected operator" error, and `>=` gets the wrong estimate.

The pg_operator.h macro swap in the fix is already handled by the current .dat symbols, so no change was made there. The default_range_selectivity and typcache hunks were not reverted.

Oracle failing case: src/test/regress||rangetypes (expected; see oracle output).
