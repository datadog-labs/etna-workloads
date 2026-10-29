# Rationale

Fix: sqlite3_backup stored `Db*` pointers (into `db->aDb[]`) which dangle when
ATTACH reallocates `aDb` (use-after-free). The fix stores indexes instead.
In 3.54.1 the destination is already looked up by name in each step and
`pSrc` is a `Btree*`, so the old `Db*` form of the bug is gone. Only the
source pointer still matters (the dest is re-found by name), so I reverted that.

Changes (src/backup.c only):
- `sqlite3_backup.pSrc` is `Db *` again (reverses fix hunk `Db *pSrc` -> `int iSrc`).
  All uses became `p->pSrc->pBt` (and `->pBt->pBt` for BtShared), as pre-fix.
- `sqlite3_backup_init()` sets `p->pSrc = &pSrcDb->aDb[i]` (reverses `findDatabase` returning an index).
- `sqlite3BtreeCopyFile()` again builds a local `Db dbSrc` wrapping `pFrom`
  (reverses removal of `dbSrc`), since `pSrc` is a `Db*`.

Oracle: backup5-2.1 (and the rest of the file after it) fails. `B step 200` after
six ATTACHes reads the freed `aDb` array, so the test run crashes/aborts.
