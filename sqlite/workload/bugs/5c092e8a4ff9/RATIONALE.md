# Rationale

The fix introduced `sqlite3ExprCodeGetColumnOfTable()`, which emits OP_Rowid
for the INTEGER PRIMARY KEY column, and used it to fill the OLD.* registers in
DELETE and UPDATE. Before the fix those registers were filled with a plain
OP_Column, which yields the NULL stored in the record for an IPK column. In
3.54.1 the helper exists and is used everywhere, so reversing the hunks does
not apply. Instead the pre-fix behaviour is restored at its use sites:

- `src/delete.c` (sqlite3GenerateRowDelete, OLD.* population): reverses the
  delete.c hunk. For `iCol==pTab->iPKey` emit OP_Column directly, as the
  pre-fix code did, so the old IPK register holds NULL.
- `src/update.c` (regOld population loop): reverses the update.c hunk, same
  treatment for the IPK column.
- `src/fkey.c` exprTableRegister(): 3.54.1 also covers the case from the FK
  side (`iCol!=pTab->iPKey` selects the rowid register). This is the same
  defect: an FK parent-key lookup reading the IPK from the OLD register. I
  reverted it to the original `iCol>=0` test, so a composite parent key
  containing the IPK reads the (NULL) register.

## Oracle failures
test/fkey2.test: fkey2-dd08e5.1.2, 1.3, 1.6 (DELETE/UPDATE on the parent
with a composite (IPK, b) FK key does not detect the child row, so no
"foreign key constraint failed"), plus fkey2-ce7c13.1.2/1.3/1.5/1.6, which
guard the same composite-IPK parent key.
