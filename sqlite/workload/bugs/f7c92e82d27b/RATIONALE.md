# Rationale
Hunk: src/where.c, wherePathSatisfiesOrderBy() (tree/src/where.c ~line 5341).
The fix changed `if( eOp & WO_ISNULL )` to `if( eOp & (WO_ISNULL|WO_IS) )` so that
`col IS ?` terms (where ? may be NULL) clear isOrderDistinct. I reverted the condition
to `eOp & WO_ISNULL` and removed the matching `testcase( eOp & WO_IS )`. The code is
otherwise identical to the pre-fix code, so IS terms on a UNIQUE index are again assumed
to match at most one row, and DISTINCT is wrongly elided.
The comment is left as in the fixed version (comments only).

Oracle: distinct2-3030 fails (after ANALYZE, `SELECT DISTINCT * FROM t0 WHERE NULL IS c0`
returns the wrong result because of the wrongly-omitted DISTINCT).
