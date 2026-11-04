# Rationale

All changes are in `datafusion/functions/src/datetime/date_bin.rs`. 55.2.0 still contained the fix verbatim, so I reversed its implementation hunks directly.

- `compute_distance`: reverts to returning `i64`. It uses plain `time_diff - (time_diff % stride)` and `time_delta - stride` instead of `checked_rem` / `checked_sub`. This reverses the fix's hunk that converted it to `Result<i64>`.
- `date_bin_nanos_interval`: calls `compute_distance(...)` without `?`, and returns `Ok(origin + time_delta)` instead of using `checked_add`.
- `date_bin_months_interval`: calls `compute_distance(...)` without `?`.

## Oracle
`date_bin_errors.slt` fails. `date_bin(interval '3 nanoseconds', arrow_cast(i64::MIN, 'Timestamp(Nanosecond, None)'))` now panics with "attempt to subtract with overflow" at date_bin.rs:345. The expected result is NULL.
