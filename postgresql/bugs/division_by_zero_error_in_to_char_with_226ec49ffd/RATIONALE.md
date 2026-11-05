# Rationale

File: src/backend/utils/adt/numeric.c (single logical change, traces to the whole of fix_impl.patch)

- const_ten restored (fix hunk 1 removed it) and power_ten_int() prototype/definition removed (hunks 2 and 4).
- get_str_from_var_sci() (hunk 3): significand computed again as var / power_var_int(const_ten, exponent, denominator, denom_scale)
  instead of power_ten_int(). For extreme exponents (to_char 'EEEE' of very small/large numerics) power_var_int
  yields a zero denominator (underflow rounding) and div_var raises "division by zero".
  The current div_var signature (extra argument) was kept.

Failing oracle case: src/test/regress||numeric
