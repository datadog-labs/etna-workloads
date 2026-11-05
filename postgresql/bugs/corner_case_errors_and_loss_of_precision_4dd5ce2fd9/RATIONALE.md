# Rationale
All changes are in src/backend/utils/adt/numeric.c, reversing fix_impl.patch:

- numeric_power(): restored the up-front "negative number raised to non-integer power" check (and the old comment). Traces to hunks 1-2.
- exp_var(): overflow guard errors for any |val| >= limit again, instead of returning zero on underflow (hunk 3).
- power_var(): removed abs_base/res_sign handling of negative bases (negative base now reaches ln_var); removed the underflow-to-zero return in the initial test; removed sig_digits (local_rscale = rscale + (int) val - ln_dweight + 8 again, losing precision/going negative); removed sign restoration and free_var(&abs_base) (hunks 4-8).

Result: large negative exponents error with overflow instead of returning 0, and precision is lost in corner cases.

Failing oracle case: src/test/regress||numeric
