# Rationale

Fix hunk reversed: `whereUsablePartialIndex()` in src/where.c, which had
`(!EP_FromJoin || iRightJoinTable==iTab)`; pre-fix it was `!EP_FromJoin`.
In 3.54.1 the equivalent is `(!ExprHasProperty(pExpr,EP_OuterON) || pExpr->w.iJoin==iTab)`;
I reverted it to `!ExprHasProperty(pExpr,EP_OuterON)`, so ON-clause terms of a LEFT JOIN can
no longer qualify a partial index on the right-hand table.

The constructAutomaticIndex hunk was not reverted: that code was rewritten
(sqlite3ExprIsSingleTableConstraint) and no longer has the same form.

Failing oracle case: index6-8.1 (EXPLAIN QUERY PLAN no longer uses partial index i8c
on t8b: `SEARCH ... USING INDEX i8c` is missing). index6-8.2 still returns correct results.
