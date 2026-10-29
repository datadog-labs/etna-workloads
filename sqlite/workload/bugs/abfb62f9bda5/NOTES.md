repro.sh: attaches a second database file, then a second connection holds a read
transaction on main while the first connection writes both files and COMMITs.

- clean: COMMIT fails with "database is locked" (EXCLUSIVE lock is taken before
  the master journal is created); no master journal is left behind; exit 1.
- buggy: the exclusive-lock call is missing, so vdbeCommit creates a master
  journal and then hits SQLITE_BUSY: assertion `rc!=SQLITE_BUSY' failed (abort,
  exit 134) and a stray test.db-mj* file is left over.
