Reproducer: repro.sql (intreal-7.21).

Adds a REAL column with DEFAULT(-140737488355328) (-2^47, the smallest value that fits in
6 bytes), indexes it, then uses `.imposter` to read the raw index content as a table.

Clean: `-140737488355328|integer|1` (stored as a compact integer in the index).
Buggy: `-140737488355328.0|real|1`. sqlite3ValueFromExpr() wrongly converts negative
integers to real, because the range check never compares against the lower bound.
