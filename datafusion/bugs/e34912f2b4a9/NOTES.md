repro.sql runs the query added by the fix: array_repeat(1, c) over three rows of i64::MAX.
The summed repeat counts overflow usize.
Clean build: "array_repeat: total repeated values overflowed usize".
Buggy build: "array_repeat: requested length exceeds maximum array size".
