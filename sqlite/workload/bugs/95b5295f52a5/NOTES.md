Adds a NOT NULL column with a REAL default (0.25) to an existing row, then runs
PRAGMA integrity_check(t1). The clean shell prints `1|0.25` and `ok`; the buggy
shell omits the column default when loading the value, so integrity_check
falsely reports a NULL value in t1.b.
