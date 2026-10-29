# Rationale

## Changed: tree/src/select.c, sqlite3ProcessJoin (line ~632)
Reverses the fix's select.c hunk: the synthesized `coalesce()` for USING/NATURAL
join columns gets `affExpr = sqlite3ExprAffinity(pFuncArgs->a[0].pExpr)` (affinity
computed eagerly, at join-processing time, when the left-hand column may still
refer to an unresolved view/subquery) instead of `SQLITE_AFF_DEFER`.

The expr.c hunks (TK_FUNCTION with SQLITE_AFF_DEFER) were left in place: resolve.c
now also uses SQLITE_AFF_DEFER, so they are still needed. SQLITE_AFF_DEFER stays defined.

## Oracle failures
joinH-15.1 and joinH-15.2 fail (wrong affinity/collation for the coalesce() result
over subquery/view sources left of a RIGHT/FULL JOIN).
