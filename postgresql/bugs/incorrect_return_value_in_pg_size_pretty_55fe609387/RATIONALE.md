# Rationale

File: src/backend/utils/adt/dbsize.c

1. `half_rounded` macro -> traces to the first fix.patch hunk. Restored the old
   "round towards positive infinity" definition `((x) + ((x) < 0 ? 0 : 1)) / 2`
   in place of "round away from zero" (`-1` for negatives). Negative sizes now round the wrong way.
2. `pg_size_pretty(bigint)` -> traces to the hunk replacing `size >>= N` with
   `size /= (1 << N)`. The loop now uses `size >>= bits` instead of
   `size /= ((int64) 1) << bits`. Arithmetic right shift rounds toward negative
   infinity, so negative values are converted differently from positive ones.

The numeric variant (`numeric_shift_right` rename) was only a refactor and is unchanged.

Failing oracle case: src/test/regress||dbsize
