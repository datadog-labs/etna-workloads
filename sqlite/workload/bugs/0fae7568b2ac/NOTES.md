Reproducer (repro.sql): from in7.test 6.0/6.1. A vector IN whose RHS is a min/max
aggregate query (`SELECT c2, min(c2) FROM t2`) on a UNIQUE-indexed column.
Clean prints `-1`; buggy prints nothing (wrong result), because the vector IN is split
into per-column terms and the bare column is no longer taken from the min() row.
