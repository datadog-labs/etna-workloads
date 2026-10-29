repro.sql creates a table whose indexes are PRIMARY KEY, UNIQUE(x,x), and UNIQUE(x,x) ON CONFLICT REPLACE (conflict-15.10/20/30), then inserts a duplicate row.
Clean: "UNIQUE constraint failed: t1.x", exit 1. Buggy: the REPLACE index is not kept last in the index list, so the assertion in sqlite3CompleteInsertion fails and the shell aborts (-6).
