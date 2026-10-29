# Rationale

## src/resolve.c, lookupname_end (authorization block)
Reverses the fix hunk in `lookupName()`. The fix made the FULL/RIGHT JOIN ... USING
case (pFJMatch, a coalesce() over all matching columns) call sqlite3AuthRead() on every
term. Pre-fix code replaced `pExpr` with `pFJMatch->a[0].pExpr` and authorized only that
first column, then fell through to the common TK_COLUMN check. I restored exactly that
(the loop became `pExpr = pFJMatch->a[0].pExpr;` followed by a separate `if`). In 3.54.1
the loop used index `i` rather than `ii`; otherwise the code was the same as the fix.

## Oracle failure
`auth-9.3` fails: the authorizer sees no `SQLITE_READ t2 x main` for
`SELECT x,y2 FROM t1 FULL JOIN t2 USING(x)`. Got `READ t1 x`, `READ t2 y2`;
expected `READ t1 x`, `READ t2 x`, `READ t2 y2`. All other 379 cases pass.
