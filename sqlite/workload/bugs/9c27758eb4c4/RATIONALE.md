# Rationale

Fix hunk reversed: the `if( pSublist==0 ){ ... }` block in `sqlite3WindowRewrite()` (src/window.c) that appends a constant expression so the subquery select list is non-empty for e.g. `SELECT row_number() OVER () FROM t1`. In 3.54.1 the block uses `sqlite3ExprInt32(db, 0)`; I deleted it (including its comment), restoring the pre-fix behaviour where pSublist stays NULL.

The other fix hunks (assert helper `sqlite3VdbeAssertAggContext`, `ALWAYS(p)`, comments, whitespace) are assertion/cosmetic only and were not changed.

Oracle: the window3 cases with `row_number() OVER ()` and no other columns fail. The build hits an assertion failure (`sqlite3ExprCodeTarget` assertion) / bad result with an empty subquery select list.
