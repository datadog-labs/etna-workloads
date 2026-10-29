# Rationale

Fix hunk (src/whereexpr.c, sqlite3WhereAddLimit): added `if( pWC->a[ii].prereqRight!=0 ) return;`
so a LIMIT is not passed to a virtual table when a WHERE term on the vtab's
cursor depends on other values (e.g. `a = COALESCE('8', a)`) and so cannot be
passed to xBestIndex.

In 3.54.1 the check is folded into the loop as
`if( leftCursor==iCsr && prereqRight==0 ) continue;`. I reverted it to
`if( leftCursor==iCsr ) continue;` (the pre-fix condition: only leftCursor was tested).
The parent-term shortcut (`pParent->prereqRight==0`) is the same check applied to
a parent term, a later addition covering the same defect; I removed it as well.

Oracle cases failing: bestindexC-3.1, 3.3 (extra rows because LIMIT 3 is pushed
to the vtab while a non-passable term exists) and 6.2.
