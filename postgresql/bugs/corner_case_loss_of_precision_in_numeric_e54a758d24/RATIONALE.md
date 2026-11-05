# Rationale

Changed hunk: `src/src/backend/utils/adt/numeric.c`, function `power_var()`.

Traces to the single fix_impl.patch hunk. I re-added the line
`local_rscale = Min(local_rscale, NUMERIC_MAX_DISPLAY_SCALE);` after the
`Max(..., NUMERIC_MIN_DISPLAY_SCALE)` line. This clamps the scale used for the
low-precision ln(base) estimate. When ln_dweight is very negative (base very
close to 1), the scale needs to exceed NUMERIC_MAX_DISPLAY_SCALE to get about 8
significant digits. With the clamp, ln(base) loses precision and the result's
precision is wrong in that corner case.

Failing oracle cases: src/test/regress||numeric
