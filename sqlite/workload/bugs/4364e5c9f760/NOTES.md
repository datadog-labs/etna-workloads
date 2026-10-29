Reproducer (repro.sql): an fts5 detail=none table with two rows of the same term, all rows deleted, then a descending-rowid query and an integrity-check.

The buggy fts5SegIterNext (reverse iteration) reads the poslist size at the wrong offset in detail=none mode. The clean shell prints nothing and exits 0. The buggy shell returns a deleted row (`1`) from the `ORDER BY rowid DESC` query, and the integrity-check then fails with "database disk image is malformed" (exit status 1).
