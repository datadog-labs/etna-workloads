# Rationale

Fix hunk reversed: `src/alter.c`, `sqlite3AlterFinishAddColumn`. The fix replaced an
unconditional `OP_SetCookie BTREE_FILE_FORMAT, SQLITE_MAX_FILE_FORMAT` with
ReadCookie/AddImm/IfPos plus `SetCookie 3`, so a legacy (format 1 or 2) database is never
promoted to 4. In 3.54.1 the logic lives in the same function (the code was moved into the
`if( v )` block). I restored the unconditional `SetCookie ... SQLITE_MAX_FILE_FORMAT` and
removed the now-unused temp register `r1`.

Effect: ALTER TABLE ADD COLUMN on a legacy-format database upgrades it to format 4, which
makes the existing DESC indexes be read with the new ordering, so they are corrupt.

Failing oracle case: alter4-10.1 (got `row 2 missing from index t1a`, expected `ok`).
The alter3 file-format checks (`get_file_format` expecting 3) pass here because they start from format 4 databases.
