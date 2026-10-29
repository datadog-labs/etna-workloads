# Rationale

Fix reversed (all in `flattenSubquery()`, src/select.c), the fix's two hunks plus its assert:

1. The fix hoisted `iNewParent = pSubSrc->a[0].iCursor;` out of the loop that
   transfers FROM terms from the subquery. I moved it back inside the loop as
   `iNewParent = pSubSrc->a[i].iCursor;`. After the loop it holds the cursor of
   the *last* subquery FROM term, not the first. This is the pre-fix code.
   `sqlite3SetJoinExpr(pWhere, iNewParent, EP_OuterON)` then marks the wrong table
   when the flattened subquery has several FROM terms.
2. I removed `assert( pSubSrc->nSrc==1 )` before `sqlite3SetJoinExpr`. The fix added it.

Oracle: `select6-13.120` fails. It expects `1` and gets an empty result, because
the wrong ON-clause cursor is used. 13.100 and 13.110 still pass, as does the rest of the file (1 error out of 88 tests).
