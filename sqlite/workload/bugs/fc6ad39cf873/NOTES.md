repro.sql sums 1 and 1<<62 with sum(). The clean shell returns 0 (exact integer sum).
The buggy shell rounds the running sum through a double, losing the low bit, so the result is non-zero.
