repro.sql: table with 0.5 among values; checks `x OR 0` vs CASE, and `sum(NOT x) WHERE x`.
The bug truncates reals to integers in OP_And/Or/Not, so 0.5 is treated as false.
Clean: 0 and 0. Buggy: 1 and 1 (0.5 gives wrong results).
