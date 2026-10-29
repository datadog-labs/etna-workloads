# Rationale

Reverts dan's 2023-12-07 "different fix" for the fts5 COMMIT-following-OOM problem, restoring the earlier fba3129d approach.

## Hunks reversed
- `fts5_main.c` `Fts5FullTable`: re-added `bInSavepoint` (fix removed it).
- `fts5_main.c` `fts5RenameMethod`: re-added `bInSavepoint = 1/0` around `sqlite3Fts5StorageRename`.
- `fts5_main.c` `fts5SavepointMethod`: back to running `INSERT ... VALUES('flush')` via `sqlite3_exec` (guarded by `bInSavepoint`) instead of `sqlite3Fts5FlushToDisk`. This is the old code verbatim. When a table is renamed and then dropped in one transaction, the SQL flush refers to a table name that no longer exists and fails.
- `fts5_index.c`: removed `Fts5Index.flushRc`, its reset in `fts5IndexDiscardData`, and its set/check in `fts5IndexFlush`. These made up the new OOM handling, so the old code did not have them.

The `fts5SetupTokendataIter` hunk and the `fts5Integrity` rename are not part of this bug (the rename is cosmetic). They are left alone.

## Oracle result
`fts5misc-18.1` fails (`DROP TABLE t2` after `CREATE VIRTUAL TABLE` + `ALTER TABLE ... RENAME` in one transaction errors). The other 122 cases pass.
