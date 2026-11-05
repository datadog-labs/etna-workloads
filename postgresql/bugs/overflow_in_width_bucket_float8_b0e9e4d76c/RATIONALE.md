# Rationale

File: src/backend/utils/adt/float.c, function width_bucket_float8().

Hunk 1 (bound1 < bound2 branch) and hunk 2 (bound1 > bound2 branch) trace to the
fix.patch hunks that added the `!isinf(bound2 - bound1)` / halved-input computation.
The current code has these inside an `else` block with a clamp. I replaced them with the
pre-fix formula `((float8) count * (operand - bound1) / (bound2 - bound1)) + 1`.
When bound2 - bound1 overflows to infinity, the quotient becomes 0 or NaN. The result is
then wrong (or an undefined float-to-int conversion) instead of the correct bucket.

I did not touch the `count <= 0` comparison, which is cosmetic.

Failing oracle case: src/test/regress||numeric
