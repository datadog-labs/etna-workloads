`repro.sql` runs `SELECT * FROM generate_series(1,5) WHERE value = (value & 14) LIMIT 3`
(the bestindexC-3.3 case; uses the built-in series extension).

The WHERE term's right side depends on the same table's column (prereqRight != 0), so it can't
be passed to the virtual table. The bug lets the LIMIT be pushed down anyway.
Clean shell prints `2` and `4`; buggy prints only `2` (the limit cuts off rows before filtering).
