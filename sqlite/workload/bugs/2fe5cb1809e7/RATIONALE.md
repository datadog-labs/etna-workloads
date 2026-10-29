# Rationale

Fix (ticket #3717) moved the setting of `p->eType = FTSQUERY_PHRASE` and
`p->pPhrase->iColumn` out of the per-token loop (where it ran only for the
first token, so never for `""`) into the final block that always runs.

In 3.54.1 `getNextString()` in `ext/fts3/fts3_expr.c` already has that final
block (the code was restructured), so I restored the pre-fix behaviour there:
`eType` and `iColumn` are set only when `nToken>0`, i.e. only if at least one
token was seen, as the old `ii==0` branch did. With `MATCH '""'` the node keeps
eType 0 (from the memset) but has a non-NULL pPhrase.

Failing oracle case: `fts3expr-7.1` (`MATCH '""'`). It aborts with the assertion
`fts3FreeExprNode: p->eType==FTSQUERY_PHRASE || p->pPhrase==0`.
