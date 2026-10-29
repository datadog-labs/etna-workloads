`repro.sh` runs `.backup temp bak.db` on an in-memory shell database, so the backup source is the TEMP schema.
`findBtree()` in backup.c has to open the temp database. The bug initialises the Parse object with the wrong connection (`pErrorDb` rather than `pDb`).
Clean: the backup succeeds. Prints `done`, rc=0.
Buggy: prints `Error: not an error` and exits with rc=1.
