# Rationale

Fix: stop caching the destination Btree* in sqlite3_backup at init time (the fix switched to Db*; 3.54.1 instead looks the Btree up lazily in sqlite3_backup_step()).

Changes in tree/src/backup.c:
1. sqlite3_backup_init(): store `p->pDest = pDest` immediately (pre-fix: `p->pDest = findBtree(...)`), removing the "do not store the pointer" logic.
2. sqlite3_backup_step(): use `p->pDest` directly instead of re-looking up via findBtree() when it is NULL. This is the old behaviour; the Btree may have been freed/replaced by sqlite3_deserialize() between init and step.

Oracle: memdb1-1110 fails with `Assertion p->pPrev==0 || p->pPrev->db==p->db` in sqlite3BtreeEnter (use of a stale Btree pointer).
