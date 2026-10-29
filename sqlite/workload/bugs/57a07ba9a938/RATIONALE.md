# Rationale

Fix hunk reversed: `if( pWhere && ExprHasProperty(pWhere, EP_Subquery) ) bComplex = 1;`
in sqlite3DeleteFrom (src/delete.c). In 3.54.1 the equivalent is
`if( sNC.ncFlags & NC_Subquery ) bComplex = 1;` just before
`wcf |= (bComplex ? 0 : WHERE_ONEPASS_MULTIROW);`. I deleted that line, so a
subquery in the WHERE clause no longer disables the multi-row one-pass DELETE.
(The other hunks only moved the bComplex declaration; not needed.)

Oracle: delete4-6.0 fails (expected `1`, got `1 3 5`): rows are deleted while
the correlated subquery still scans the same table. delete4-6.1 still passes.
