# Rationale
File: src/backend/utils/adt/float.c, function dpow().
Traces to the fix.patch hunk in dpow() that made the EDOM/NaN handling skip NaN inputs (`&& !isnan(arg1) && !isnan(arg2)`).
In current code that protection is the explicit NaN early-return block; I removed it. NaN inputs now reach pow() and the post-check `errno == EDOM || isnan(result)`, which treats the NaN result as a domain error and ends in a spurious overflow/underflow error instead of returning NaN (or 1 for NaN^0 / 1^NaN).

Failing oracle case: src/test/regress||float8
