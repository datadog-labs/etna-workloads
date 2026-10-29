repro.sql sums 9223372036854775807 and 10 (integer overflow in sum()).
Clean: "Error near line 1: integer overflow", exit status 1.
Buggy: returns 9223372036854775807 (the overflowed sum is clamped to an int64), exit status 0.
