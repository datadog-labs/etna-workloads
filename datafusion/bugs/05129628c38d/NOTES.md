Reproducer: date_trunc('hour', arrow_cast(i64::MAX, 'Timestamp(Second, None)')). Clean build returns an 'out of range' execution error; buggy build panics on multiply overflow (exit 101).
