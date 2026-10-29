With the bug, PRIMARY KEY columns of WITHOUT ROWID tables always get NOT NULL ON CONFLICT ABORT, ignoring an explicit ON CONFLICT clause.
repro.sql uses IGNORE (clean: NULL row skipped, other rows inserted; buggy: constraint error) and REPLACE DEFAULT 3.
