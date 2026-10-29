# Rationale

All changes are in `tree/src/alter.c`, `renameEditSql()`; they reverse the single implementation file in fix.patch (three hunks).

1. zQuot construction: restored `"\"%w\""` (no trailing space), `nQuot = strlen(zQuot)` (no `-1`), and the `if( bQuote ){ zNew=zQuot; nNew=nQuot; }` block that the fix removed.
2. Replacement condition: restored `if( sqlite3IsIdChar(*pBest->t.z) )` instead of `bQuote==0 && ...`. With bQuote the pre-fix code relies on zNew having been swapped to the quoted form.
3. Removed `if( pBest->t.z[pBest->t.n]=='"' ) nReplace++;`, which let the replacement swallow a trailing character when a quoted string followed the token.

Oracle failure: `altercol-23.0` (`CREATE TABLE t1('a'"b",c)` then RENAME COLUMN a TO x) now produces wrong schema SQL, since the quoted replacement abuts the following `"b"` token. The other 257 cases pass.
