repro.sh: connection B (a coprocess shell) reads once, so it maps only the first 32KB chunk of the -shm file. Another connection then writes about 150000 rows (~15000 WAL frames) and fully checkpoints them. B then runs BEGIN; INSERT; ROLLBACK.

Clean: prints 0 and 1, exit status 0.
Buggy: sqlite3WalUndo calls walCleanupHash unconditionally, so the assert `pWal->nWiData>walFramePage(pWal->hdr.mxFrame)` fails and B aborts. The output shows the assertion message and "Aborted". The script's own exit status is still 0.
