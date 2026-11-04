repro.sql runs `generate_series(9223372036854775806, 9223372036854775807, 2)` and a date series starting at DATE '0001-01-01'.

- df-clean: the first query returns the single row 9223372036854775806. The second fails with a planning error ("First argument for generate_series is out of range of nanosecond timestamps"). Exit status 0.
- df-buggy: the first query panics with "attempt to add with overflow" at the i64 boundary, and the process exits with status 101. The date query is never reached.
