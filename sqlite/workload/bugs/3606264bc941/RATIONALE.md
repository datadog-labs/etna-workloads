# Rationale

## Change (tree/src/fkey.c, sqlite3FkCheck)
Removed the loop body that maps child key columns equal to `pTab->iPKey` to `-1` in `aiCol`
(`if( aiCol[i]==pTab->iPKey ){ aiCol[i] = -1; }`).

This reverses the fix hunk that added that remapping (the `aiFree`/`aiCol`/`iCol` block in
sqlite3FkCheck). Without it, an INTEGER PRIMARY KEY child column keeps its column index
instead of -1, so fkLookupParent computes the wrong register (the rowid lives at regData, not
at the column's slot) and ends up using the wrong value. This is the pre-fix behaviour: the
IPK is treated as an ordinary column. The other fix hunks (use of aiCol in fkCheckReference)
are already expressed through aiCol in the current code, so only the remapping needed to go.

## Oracle failures
In the oracle run, fkey2-16.1.3.1 aborts on the debug assertion
`aiCol[i]!=pTab->iPKey` in fkLookupParent, and the run stops there. In non-assert builds the
IPK-as-child-key cases (fkey2-7.x) would read wrong registers and give wrong results.
