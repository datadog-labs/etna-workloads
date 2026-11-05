# Rationale

File/function: src/backend/access/brin/brin_minmax_multi.c, `brin_minmax_multi_distance_date`.
Traces to the single fix_impl.patch hunk. The fix computes the distance as `(float8) dateVal2 - (float8) dateVal1` (non-negative, in float8) and asserts delta >= 0. I restored the buggy form `PG_RETURN_FLOAT8(dateVal1 - dateVal2)`. That subtracts as int32 (can overflow and gives the wrong sign/order) and is negative when dateVal1 < dateVal2, so the distance is wrong for the multi-range summary.

Failing oracle case: src/test/regress||brin_multi
