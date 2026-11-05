# Rationale

File: src/backend/utils/adt/numeric.c, function power_var_int()

Traces to the fix.patch hunks that change `exp = Abs(exp)` into an `unsigned int mask = Abs(exp)` (the loop variable).
- `mask` is now a signed `int` again, set with `abs(exp)`.
- For exp = INT_MIN, `abs()` stays negative, so `(mask >>= 1) > 0` is false at once and the loop never runs. The result is wrongly 1 (or 1/1) instead of overflow/underflow.
- The overflow-bailout hunk is already present in today's code and was left alone.

Failing oracle case: src/test/regress||numeric
