Creates a WITHOUT ROWID table whose UNIQUE column is also its PRIMARY KEY (redundant UNIQUE), adds an index, inserts a row, and runs VACUUM, integrity_check and a sqlite_master query.

Clean: `ok`, and sqlite_master lists only t47 and i47.
Buggy: integrity_check reports "Page 2: never used", and a spurious sqlite_autoindex_t47_1 entry appears in sqlite_master.
