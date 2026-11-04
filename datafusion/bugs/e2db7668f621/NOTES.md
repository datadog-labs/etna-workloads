repro.sql runs `nth_value(x, -9223372036854775808) OVER (ORDER BY x)` over a one-row VALUES.
Clean build: returns the execution error "The second argument of nth_value must not be i64::MIN" (exit 0).
Buggy build: panics with "attempt to negate with overflow" in nth_value.rs (exit 101).
