# Rationale

## src/where.c, sqlite3WhereBegin(): False-WHERE-Term-Bypass loop
The fix added condition (3): a term from an inner ON clause (EP_InnerON) must
not trigger the bypass when the leftmost table has JT_LTORJ (the join contains
a RIGHT/FULL join). In 3.54.1 that condition is the
`!(ExprHasProperty(pX, EP_InnerON) && (pTabList->a[0].fg.jointype & JT_LTORJ)!=0)`
clause. I removed it, restoring the pre-fix test of only `prereqAll==0` and
determinism. A constant-false ON term (e.g. `ON (0)`) then jumps to iBreak and
skips the whole loop, including the RIGHT/FULL JOIN unmatched-row pass.

## Oracle failures
test/joinH.test: joinH-5.1, 5.2 and 5.4 fail. They return no rows instead of
the rows from the right-hand table, e.g. `t1 INNER JOIN t2 ON (0) RIGHT OUTER JOIN t3`
should give `{} {} t3val`.
