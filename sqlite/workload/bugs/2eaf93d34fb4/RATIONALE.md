# Rationale

Bug (ticket #3060): IEEE NaN read from a database record must be treated as NULL.

## Changes
- `src/vdbeaux.c` `sqlite3VdbeSerialGet7()`: removed the `IsNaN(x)` check, so the cell is always `MEM_Real`.
  Reverses the fix hunk in `sqlite3VdbeSerialGet` (`pMem->flags = sqlite3IsNaN(pMem->r) ? MEM_Null : MEM_Real;` -> `MEM_Real`).
  The function's old NaN return value (1) is now always 0, which only affects record-comparison callers for NaN.
- `src/vdbe.c` `OP_Column` serial type 7: `IsNaN(x) ? MEM_Null : MEM_Real` -> `MEM_Real`.
  This is the same defect on the second, inlined deserialisation path.

## Not reverted
- `codeReal` hunk (OP_Null for NaN literals): today's `sqlite3AtoF` never returns NaN (asserted in expr.c), so it cannot be brought back.
- `OP_Real` assert: assertion only.

## Oracle
`./check.sh`: nan-3.3, nan-3.4, nan-3.5, nan-3.6 fail. These write a NaN bit pattern into the database file with hexio_write and expect `{} null`. They now get a real-typed NaN.
