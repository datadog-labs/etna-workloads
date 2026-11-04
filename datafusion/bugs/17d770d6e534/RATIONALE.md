# Rationale

In 55.2.0 the Result-plumbing of the fix (BinFunction, `?`, `.ok()` -> NULL) is already present, but the month-path checks were refactored into `shift_months`. Changes in `datafusion/functions/src/datetime/date_bin.rs`:

- `shift_months`: reverts the `checked_sub_months`/`checked_add_months` + `exec_err!` hunks back to `origin_date - Months` / `origin_date + Months`, which panic ("`DateTime - Months` out of range"). `shift_months` is the helper holding both former inline sites (both call sites in `date_bin_months_interval`).
- `date_bin_months_interval`: reverts the `match bin_time.timestamp_nanos_opt()` hunk to `.unwrap()`.

The `to_utc_date_time` Result change is left in place (the rest of the Result plumbing remains).

Oracle: date_bin_errors.slt fails; the first query (interval '1637426858 months') panics with "`DateTime - Months` out of range" instead of returning NULL.
