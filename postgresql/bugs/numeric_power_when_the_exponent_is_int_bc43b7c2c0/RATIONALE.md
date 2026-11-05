# Rationale
File/function: src/backend/utils/adt/numeric.c, power_var_int()
Traces to the fix.patch hunk replacing `log(Abs(exp))`-style integer abs with `log(fabs(...))`.
Change: `log(fabs((double) exp))` -> `log(abs(exp))`. With exp == INT_MIN, abs() overflows
(stays negative), so log() of a negative gives NaN/garbage and sig_digits is wrong,
reintroducing the bug in numeric_power() with exponent INT_MIN.

Failing oracle case: src/test/regress||numeric
