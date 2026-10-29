# Rationale

Changed: `ext/fts5/fts5_expr.c`, `sqlite3Fts5ExprClonePhrase()`.

Reverses the fix hunk that added the `else` branch to `if( pOrig->nTerm )`. That
branch allocates an empty `Fts5ExprPhrase` for a zero-term phrase (e.g. `""` or
`"/"`). I removed it, so a zero-term phrase leaves `sCtx.pPhrase==0`. The
function then returns `rc==SQLITE_OK` with `*ppNew==0`. Callers, such as the
auxiliary function API used by bm25, then crash. In an assert build the
`ALWAYS(sCtx.pPhrase)` check fails first.

I did not touch the `fts5ExprNearInitAll` hunk. Current code already handles
zero-term phrases explicitly (`nTerm==0` sets `bEof`), so that hunk's mechanism
no longer exists in that form.

Oracle failure: `fts5eb-3.3` (`'"/" OR "just"' ORDER BY rank` with bm25) aborts with
`sqlite3Fts5ExprClonePhrase: Assertion '0' failed`. Cases 3.0-3.2 still pass.
