# Rationale

Fix: ALTER TABLE on an eponymous virtual table (e.g. generate_series) must raise
"table X may not be altered". The fix added TF_Eponymous, set it in
sqlite3VtabEponymousTableInit(), and tested it in isAlterableTable().

In 3.54.1 the flag and its assignment (src/vtab.c) still exist and are also used
by build.c, so only the check was removed.

## Changed hunk
- src/alter.c isAlterableTable(): dropped `|| (pTab->tabFlags & TF_Eponymous)!=0`
  (reverses the alter.c hunk). The condition is again just sqlite_ prefix / read-only shadow table.

The `NEVER(pPtr==0)` hunk in renameTokenFind was not reverted (not needed for the bug).

## Oracle failures
tabfunc01-810, 820, 830, 910, 920, 930: RENAME TO / RENAME COLUMN / DROP COLUMN on
eponymous vtabs no longer give "table ... may not be altered" (ADD COLUMN cases still pass
via the separate "virtual tables may not be altered" check).
