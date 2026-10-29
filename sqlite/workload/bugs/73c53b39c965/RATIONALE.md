# Rationale

Fix (2019-05-15) added `if( p->pWhere ) return 0;` and `if( p->pGroupBy ) return 0;`
to `countOfViewOptimization()` in src/select.c (the comment-only hunk and manifest
hunks need no reversal).

In version-3.54.1 the function has the same checks (plus later-added pHaving/pOrderBy
checks). I removed the `p->pWhere` and `p->pGroupBy` checks only; the pHaving and
pOrderBy checks are unrelated to this fix and left intact. The function is otherwise
identical in structure, so this restores the pre-fix behaviour: the count(*)-of-UNION-ALL
view rewrite is applied even with a WHERE or GROUP BY on the outer query.

## Oracle failures
`./check.sh`: countofview-2.0 (`SELECT count(*) FROM v1 WHERE x<>1`) hits an assertion
failure in sqlite3VdbeExec (`pC!=0`) and the run aborts, so 2.1 and all later cases
are also reported failing (incomplete run). Without asserts, the WHERE would be
ignored (wrong count) and GROUP BY would yield one row instead of `3 3`.
