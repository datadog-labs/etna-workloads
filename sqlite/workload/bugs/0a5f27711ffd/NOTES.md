Reproducer (`repro.sql`): inserts 9007199254740993 (integer), 9007199254740992.0 and 0.5 into a table,
runs `ORDER BY x` (sorter), creates an index, then runs `PRAGMA integrity_check`.

Clean: order is 0.5, 9007199254740992.0, 9007199254740993; integrity_check says `ok`.
Buggy: the sorter compares the 64-bit integer as a double, so the two large values sort in the wrong order,
and integrity_check reports `row 2 missing from index i`.
