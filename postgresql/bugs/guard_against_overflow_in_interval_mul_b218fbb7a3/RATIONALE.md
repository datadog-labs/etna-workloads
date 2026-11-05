# Rationale

All changes are in src/backend/utils/adt/timestamp.c. They trace to the matching hunks of fix_impl.patch (the fix is reversed).

- `interval_mul()`: the `pg_add_s32_overflow` guards are removed. `result->day += (int) (sec_remainder / SECS_PER_DAY)` and `result->day += (int32) month_remainder_days` are plain additions again, so they can silently overflow int32. This reverses the fix hunk that added those guards.
- `interval_div()`: the same two `result->day` guards are removed, for the same reason.
- `interval_div()`: the `FLOAT8_FITS_IN_INT32` range checks on month and day are removed, so `(int32) (span->month / factor)` and `(int32) (span->day / factor)` are unchecked casts that are undefined when out of range. The `FLOAT8_FITS_IN_INT64` check on time is also removed, so `rint(...)` is assigned straight to `result->time`. These reverse the hunks that added the checks and the `result_double` use.

I left the `out_of_range` label and the `goto` statements in place. They are harmless and still used by other paths.

## Failing oracle cases
- src/test/regress||interval
