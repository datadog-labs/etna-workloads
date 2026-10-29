# Rationale

## Changed hunk
`src/window.c`, `selectWindowRewriteExprCb()`: removed the `case TK_AGG_FUNCTION:` label
that sits in front of `case TK_COLUMN:`.

Reverses fix hunk `@@ -434,6 +553,7 @@` in window.c, which added `case TK_AGG_FUNCTION:` so
that aggregate function nodes are treated as terminals, i.e. are pushed into the
sub-query's result list and replaced by a column reference to the ephemeral table.
Without it (the pre-fix state), an aggregate in a windowed aggregate query such as
`SELECT max(c), max(b) OVER (ORDER BY b) FROM ttt GROUP BY b` is left in the outer query
while the GROUP BY moves to the sub-query, so the aggregate is evaluated in the wrong place.

## Not reversed
- select.c `isAgg` move: in 3.54.1 `isAgg` is already computed after `sqlite3WindowRewrite()`.
- window.c `p->selFlags &= ~SF_Aggregate` / `sqlite3SelectPrep(pSub)`: 3.54.1 restructured this
  (clears the flag earlier and sets the sub-select's flags differently); the TK_AGG_FUNCTION
  omission alone restores the bug.

## Oracle result
`./check.sh`: window4-4.1 fails (1 error out of 226); everything else passes.
