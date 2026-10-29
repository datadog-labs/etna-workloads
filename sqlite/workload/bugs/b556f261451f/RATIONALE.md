# Rationale

## Changed hunk
`src/window.c`, `selectWindowRewriteSelectCb()`. The fix replaced the body
(`UNUSED_PARAMETER` x2, `return WRC_Prune`) with code that walks the scalar
sub-select with `p->pSubSelect` set, so outer-query TK_COLUMN references inside
it get rewritten to read the ephemeral table. I restored the pre-fix body: the
callback prunes and never descends into sub-selects. The `pSubSelect`/`pSrc`
logic in `selectWindowRewriteExprCb` is left in place but is now never
reached (pSubSelect stays 0), the same as before the fix.

## Oracle failure
`window6-11.2` fails: the scalar sub-select `(SELECT y FROM t3 WHERE x=a)` in a
window query returns NULL instead of `ten`/`fifteen`/`thirty`, because `a`
inside the sub-select is not redirected to the ephemeral table.
