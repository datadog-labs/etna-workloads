# Rationale
File: src/backend/utils/adt/cash.c

The current code routes the operators through shared helpers. The old per-function `rint()` calls now live in those helpers.

- `cash_mul_float8()`: I removed `rint()`. This reverses the fix hunks for `cash_mul_flt8`, `flt8_mul_cash`, `cash_mul_flt4` and `flt4_mul_cash`, which added `rint(c * f)`. The product is now truncated when converted to int64 instead of rounded.
- `cash_div_float8()`: I removed `rint()`. This reverses the `cash_div_flt4` hunk (`rint(c / (float8) f)`), and the same helper serves `cash_div_flt8`. Float division now truncates.
- The int2/int4/int8 division hunks (`rint(c / i)` -> `c / i`) are already in their post-fix form. The code truncates there, as the fix intended, so I made no change.

Failing oracle case: src/test/regress||money. `'878.08'::money / 11::float8` gives $79.82 instead of $79.83.
