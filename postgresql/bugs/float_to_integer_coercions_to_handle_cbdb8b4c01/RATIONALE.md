# Rationale

The fix made float-to-integer casts round with rint() first, then range-check against exact float boundaries (`FLOAT*_FITS_IN_INT*`, which replaced the older `num >= MIN && num < -MIN` form). I restored the old order: check first, round after.

Hunks (all trace to the matching hunks in fix_impl.patch):
- `src/backend/utils/adt/float.c`, `dtoi4`, `dtoi2`, `ftoi4`, `ftoi2`: removed the up-front `num = rint(num)` and the `FLOAT*_FITS_IN_INT*` check. Restored `num < INT_MIN || num > INT_MAX || isnan(num)` (SHRT_* for the 16-bit versions) and `rint()` in the return.
- `src/backend/utils/adt/int8.c`, `dtoi8`, `ftoi8`: removed the up-front rint and the FITS check. Restored the `> PG_INT64_MAX` comparison, which is inexact because PG_INT64_MAX rounds up to 2^63 as a float, and `rint()` in the return.

Bug restored: values just outside the range that would round into it are wrongly rejected, e.g. 2147483647.5 and -2147483648.5 for int4. At the upper int8 boundary, 2^63 passes the `>` check and the cast is undefined behavior.

Failing oracle cases: src/test/regress||float4, src/test/regress||float8
