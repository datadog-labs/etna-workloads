# Rationale

Changed: src/backend/utils/adt/numeric.c, numeric_mul_opt_error().
Traces to the fix_impl.patch hunk that adds `if (result.dscale > NUMERIC_DSCALE_MAX) round_var(&result, NUMERIC_DSCALE_MAX);` after mul_var(). I removed that check (the comment and the NUMERIC_DSCALE_MAX macro are left alone, since the macro is used elsewhere now). Without it, a product whose exact result has more than 0x3FFF digits after the decimal point is passed to make_result unrounded, so the dscale overflows (the original bug).

Failing oracle cases: src/test/regress||numeric
