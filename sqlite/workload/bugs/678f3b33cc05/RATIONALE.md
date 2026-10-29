# Rationale

Fix hunk reversed: src/alter.c `dropColumnFunc` — the fix saved `db->xAuth`, set it to 0 for the
duration of renameParseSql, and restored it at `drop_column_done`. In 3.54.1 that code is still
present in dropColumnFunc (with the same `#ifndef SQLITE_OMIT_AUTHORIZATION` guards); I removed both
the save/clear block and the restore, restoring the pre-fix behaviour. (The fix's other hunk, removing a
stray `return;`, is cosmetic.)

Oracle: test/alterauth2.test alterauth2-1.3 fails (and the rest of the file does not run) with
`Assertion !IN_RENAME_OBJECT || db->xAuth==0` in realAuthCheck: ALTER TABLE ... DROP COLUMN with an
authorizer registered runs the authorizer during the rename parse.
