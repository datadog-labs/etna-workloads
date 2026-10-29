repro.sql: fts5 with pgsz=32, 201 inserts, optimize, delete, optimize again, integrity-check.
Clean: no output, exit 0. Buggy: 'fts5: checksum mismatch for table "x1"', exit 1 (optimize merges segments in wrong order and corrupts the index).
