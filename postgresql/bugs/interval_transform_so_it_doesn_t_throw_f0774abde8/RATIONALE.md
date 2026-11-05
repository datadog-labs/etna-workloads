# Rationale

File: src/backend/utils/adt/timestamp.c

1. `interval_support()` (the code that was `interval_transform` in the fix) — traces to the
   fix_impl.patch hunk that rewrites the no-op test. I restored the old logic. It compares
   `fls()` of the old and new range bitmaps instead of the least-significant field. It decides
   "no-op" with the old condition: `new_range_fls >= SECOND || new_range_fls >= old_range_fls`.
   That condition is wrong. The `new_range_fls >= SECOND` clause treats any target range that
   includes SECOND as a no-op, so a cast such as `interval day to second` applied to a
   `interval day to hour` source is relabeled instead of kept. The result is that non-no-op
   casts, which should truncate fields, are thrown away.

2. `intervaltypmodleastfield()` — traces to the fix hunk that added this helper. It is removed,
   since the restored code no longer uses it.

## Failing oracle cases
- src/test/regress||interval (verified: oracle reports FAIL)

Note: `fls()` no longer exists in the current tree, so the restored code computes it as
`x ? pg_leftmost_one_pos32(x) + 1 : 0` (same semantics).
