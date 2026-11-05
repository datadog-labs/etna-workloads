# Rationale
Hunk 1: src/backend/utils/adt/float.c, dpow(): removed the explicit NaN-handling block (NaN^0=1, 1^NaN=1, otherwise NaN). Traces to the first fix_impl.patch hunk (which added it). Without it, NaN inputs reach pow(); the later `errno == EDOM || isnan(result)` check (today's code no longer has the `!isnan(arg1) && !isnan(arg2)` guard in the same form) treats the NaN result as a domain error and raises a bogus overflow/underflow error, and NaN^0 / 1^NaN are left to platform pow().
(The second/third hunks' guard was already generalized in current code; the removed block is the essential part.)

Failing oracle case: src/test/regress||float8
