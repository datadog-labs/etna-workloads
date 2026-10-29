# Rationale

Fix hunk (src/alter.c, renameColumnFunc): before walking `pCheck`/index
expressions, set `sCtx.iCol = -1` when the renamed column is the INTEGER
PRIMARY KEY, so that CHECK references to the rowid alias (TK_COLUMN with
iColumn==-1) are matched and renamed.

In 3.54.1 that logic was moved up: `sCtx.iCol` was initialised to
`(iCol==pTab->iPKey) ? -1 : iCol`. Changes (src/alter.c, renameColumnFunc):

- `sCtx.iCol = iCol;` : drops the IPK -> -1 mapping, i.e. the pre-fix state in
  which the CHECK walk compares against the real column index and never matches
  IPK references (iColumn==-1).
- `if( sCtx.iCol<0 )` became `if( iCol==pTab->iPKey )` : keeps the
  separate IPK-token lookup behaving as before (it depended on sCtx.iCol<0).

Oracle: altercol-6.1 (the fix's added test, RENAME of IPK `rid` used in a CHECK)
fails, plus other IPK-related altercol cases (6.2, 8.x, 9.x) - 19 of 248 fail.
