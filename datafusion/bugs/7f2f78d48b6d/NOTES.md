`repro.sql` runs AVG as a sliding window aggregate (`ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING`) over trailing NULLs, once with INT input (Float64 path) and once with DECIMAL(10,2) input.

- df-clean: rows 3 and 4 are NULL in both queries. Exit status is 0.
- df-buggy: the INT query returns NaN for rows 3 and 4. The DECIMAL query panics with "attempt to divide by zero" and exits with status 101.

Cause: after `retract_batch` empties the frame, `count` is 0 but `sum` is still `Some(..)`. The buggy `evaluate()` divides by the zero count.
