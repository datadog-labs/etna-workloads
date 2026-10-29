Reproducer (repro.sql): WITHOUT ROWID table with a DESC integer primary key and a UNIQUE column, five rows, then REINDEX and PRAGMA integrity_check.

Clean shell prints `ok`. Buggy shell prints "row N missing from index sqlite_autoindex_t0_2" for rows 1-4. The buggy build always uses OP_SeekEnd when refilling the index, but that index's key order differs from the main table's because the primary key is DESC.
