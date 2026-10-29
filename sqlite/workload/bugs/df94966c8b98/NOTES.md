Reproducer: creates a WITHOUT ROWID table with `INTEGER PRIMARY KEY UNIQUE`, adds an index, inserts a row, and lists sqlite_master.
Clean: `table t1 | index t1x |`. Buggy: an extra sqlite_master entry (or error) appears for the table, because the PK btree's root-page opcode isn't bypassed.
