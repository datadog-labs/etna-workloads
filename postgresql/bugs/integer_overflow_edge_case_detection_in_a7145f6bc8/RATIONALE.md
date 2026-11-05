# Rationale
Hunk: src/backend/utils/adt/timestamp.c, interval_mul() — traces to the timestamp.c hunk of fix.patch.
The range check on the time field was changed from `isnan(result_double) || !FLOAT8_FITS_IN_INT64(result_double)` back to `result_double > PG_INT64_MAX || result_double < PG_INT64_MIN`.
PG_INT64_MAX converts to 2^63 as a double, so a result of exactly 2^63 passes the check, and NaN compares false so it passes too. The following (int64) cast then overflows.
Other hunks of the fix (float.c, int8.c, pgbench, c.h macros) were not touched. interval_mul is the only place the oracle test exercises.

Failing oracle case: src/test/regress||interval
