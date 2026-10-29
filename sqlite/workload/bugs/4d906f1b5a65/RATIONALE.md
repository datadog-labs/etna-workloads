# Rationale

Reverted all three code hunks of the fix in `tree/src/update.c`:

1. `updateFromSelect()`: the `pPk` branch again uses `eDest = SRT_Upfrom` instead of
   `IsVirtual(pTab) ? SRT_Table : SRT_Upfrom` (fix hunk 1). Only reachable for virtual
   tables via the WITHOUT ROWID path below, so the destination is the wrong one.
2. `updateVirtualTable()`: removed the `HasRowid(pTab)` / primary-key-column branch, going
   back to always using `pRowid` or `TK_ROW` as the first ephemeral-table column (fix hunk 2).
   For a WITHOUT ROWID vtab, TK_ROW is used instead of the PRIMARY KEY value.
3. `updateVirtualTable()` passes `0` instead of `pPk` to `updateFromSelect()` (fix hunk 3).

Oracle failures: vtabJ-210 and vtabJ-220 (UPDATE ... FROM on the WITHOUT ROWID tclvar
vtab) fail with "prohibited TCL variable change"; the wrong key is passed to xUpdate.
