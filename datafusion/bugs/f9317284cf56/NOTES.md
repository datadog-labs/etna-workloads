`repro.sql` runs `date_bin(interval '1 month', ...)` on a negative sub-second timestamp (`to_timestamp_millis(-1040292460)`, before the epoch). It does this once with a scalar input and once with an array input.

The clean build returns `1969-12-07T00:00:00` for both. The buggy build returns `NULL` for both, because `to_utc_date_time` uses truncating `/` and `%` instead of `div_euclid` and `rem_euclid`. That leaves a negative nanosecond part, which wraps when cast to `u32`, so `DateTime::from_timestamp` fails.
