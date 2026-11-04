Reproducer: repro.sql runs lead/lag window queries with extreme offsets (i64::MIN / i64::MAX) over a 3-row table,
copied from lead_lag_extreme_offsets.slt. The clean build returns the default / NULL for every row. The buggy build
negates and casts the offset without overflow handling, so it errors or panics (see ./check.sh output for the exact difference).
