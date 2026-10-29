# Rationale

Fix (CVS 3374): in `sqlite3Insert`, `INSERT ... SELECT` into a virtual table
copied columns with `OP_Dup, i+nColumn-j` which ignored the extra leading
register a virtual table's row has (the "old rowid" slot); the fix added
`+IsVirtual(pTab)`.

## Change (src/insert.c, sqlite3Insert, co-routine setup)
`dest.iSdst = bIdListInOrder ? regData : 0;` became
`dest.iSdst = bIdListInOrder ? regData - (IsVirtual(pTab) ? 1 : 0) : 0;`

The OP_Dup stack-relative code no longer exists; today the SELECT result is
placed in registers (`regData`) or copied from `regFromSelect+k`. Omitting the
virtual-table extra register in that offset is the same defect: the select
output is placed one register off for virtual tables, so columns are shifted
and the last column's register is uninitialised. (Reverting the other spot,
`regIns = regRowid - IsVirtual`, was tried but is only reached for multi-row
VALUES co-routines, not the oracle.)

## Oracle failures
vtab9-1.1 and vtab9-1.2 both fail: the VDBE asserts `memIsValid(pX)` in
sqlite3VdbeExec (uninitialised register read) in the debug build.
