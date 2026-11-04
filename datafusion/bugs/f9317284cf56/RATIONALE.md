# Rationale

## Changed: `to_utc_date_time` in datafusion/functions/src/datetime/date_bin.rs
Reverses the fix hunk that replaced `nanos / NANOS_PER_SEC` and `nanos % NANOS_PER_SEC`
with `div_euclid` / `rem_euclid`. The pre-fix code is restored verbatim: for negative
sub-second values the remainder is negative, and `as u32` wraps it into a huge
nanosecond count, so `DateTime::from_timestamp` returns None ("Invalid timestamp value").
The binning error is then turned into NULL.

The other fix hunks (checked scaling, `validate_time_stride`, scalar/array NULL consistency)
were not reverted, because 55.2.0 differs from the pre-fix code there and each is a separate defect.

## Oracle failures
date_bin_errors.slt fails with two mismatches. These are the scalar and array queries on
`to_timestamp_millis(-1040292460)` with a `1 month` stride. Expected `1969-12-07T00:00:00`, got `NULL`.
