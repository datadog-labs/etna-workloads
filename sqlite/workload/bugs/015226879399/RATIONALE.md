# Rationale

## Change
`tree/src/alter.c`, `sqlite3AlterRenameTable()`: in the nested
`UPDATE sqlite_schema SET tbl_name=..., name=...` statement, the clause
`WHERE tbl_name=%Q COLLATE nocase AND (...)` was changed back to
`WHERE tbl_name=%Q AND (...)`.

This reverses the single implementation hunk of the fix, which added
`COLLATE nocase`. The line is unchanged from the pre-fix code apart from
the schema-name quoting, so the revert is exact. Without it, a trigger whose
`tbl_name` was recorded in a different case than the table (e.g. `ON T6` for
table `t6`) is not matched, so its `tbl_name` is not updated on rename.

## Oracle failures
- `test/tkt3838.test` tkt3838-1.2: `ALTER TABLE T1 RENAME TO XYZ2` fails with
  "error in trigger r1 after rename".
- `test/alter.test` alter-3.1.2, 3.1.4 – 3.1.8: the trigger on `T6` is not
  carried through the rename.
