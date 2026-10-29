# Rationale

The fix replaced the backup object's index-based references to its databases
(`iSrc`/`iDest` into `db->aDb[]`) with cached `Btree*` pointers and a stored
destination name. Version 3.54.1 already contains the fixed (pointer) design,
so I restored the pre-fix index design by reverse-applying the implementation
hunks of fix.patch in `src/backup.c`, `src/btree.h` and `src/vacuum.c`.

- backup.c struct / `findBtree` -> `findDatabase` / `setDestPgsz`: `iDest`, `iSrc`
  ints, the `getSourceBtree`/`getDestBtree` macros, and `findDatabase` returning
  an index (hunks 1-5; hunk 3 applied by hand because of an added assert).
- `sqlite3_backup_init`: no `zDestDb` copy, stores indices (hunk 6-7).
- `backupOnePage`, `backup_step`, `backup_finish`, `backupUpdate`,
  `BackupRestart`: Btree is re-derived from `aDb[index]` on each use.
- `sqlite3BtreeCopyFile(sqlite3*, int, int)` and its caller in vacuum.c, btree.h.
- build.c hunk (a commented-out line) was not reverted; it is a no-op.

Pre-fix behaviour: `sqlite3CollapseDatabaseArray()` (after DETACH) moves `aDb`
entries without updating a live backup's indices, so the backup then refers to
the wrong (or freed) Btree.

## Oracle failures
test/backup5.test: backup5-2.3 crashes (DETACH aux4 between backup steps from
aux7 shifts aDb), so 2.3 and everything after (2.4, 3.0-3.5) fail as an
incomplete run.
