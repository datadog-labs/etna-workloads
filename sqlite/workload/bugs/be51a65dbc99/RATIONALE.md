# Rationale

Fix (ticket #3424): OP_NullRow now calls `sqlite3BtreeClearCursor()` on the
btree cursor so that a following OP_Next/OP_Prev sees no more rows.

The `btree.c`/`btree.h` hunks only renamed `clearCursorPosition` to the exported
`sqlite3BtreeClearCursor`. That rename is already present in 3.54.1 and is not
reverted.

## Change
`src/vdbe.c`, OP_NullRow: removed the block
```c
if( pC->eCurType==CURTYPE_BTREE ){
  sqlite3BtreeClearCursor(pC->uc.pCursor);
}
```
This reverses the fix's vdbe.c hunk, which added the clear call. The 3.54.1
form differs only in using `eCurType==CURTYPE_BTREE` instead of `pC->pCursor`.
Without it, the cursor keeps its position after NullRow, so a later OP_Next
continues from the old position.

## Oracle results
`test/tkt3424.test`: tkt3424-1.2 and tkt3424-1.4 fail. The LEFT JOIN returns
extra rows (`2 {} BBB AAA E3`, `... E4`, `... E5`) instead of a single
null-extended row. Cases 1.1 and 1.3 are setup only and still pass.
