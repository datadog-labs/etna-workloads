repro.sql runs the four Date32/Date64 +/- INTERVAL '999999' YEAR queries from the added slt test.
Clean build: each prints a "Date arithmetic overflow" error (exit 0).
Buggy build: panics with `unreachable` in interval_arithmetic.rs (get_extreme_value lacks Date32/Date64), exit 101.
