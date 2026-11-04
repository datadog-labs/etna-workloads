repro.sql runs a BETWEEN filter with the full i64 range over a VALUES row.
Clean: returns the row (exit 0). Buggy: panics "attempt to add with overflow"
in Interval::cardinality (exit 101), because `result + 1` overflows instead of checked_add.
