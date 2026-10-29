# Rationale

Fix hunk reversed: src/window.c in sqlite3WindowRewrite(), the fix added
`u32 selFlags = p->selFlags;` and `pSub->selFlags |= (selFlags & SF_Aggregate);`
after sqlite3ResultSetOfSelect(), so the sub-select keeps the aggregate flag when the
outer query is an aggregate with no GROUP BY. Both lines were still present in
3.54.1 (src/window.c); I removed them. The rewritten subquery therefore loses SF_Aggregate,
as before the fix.

The other fix hunk (removing `assert( p->pWin==0 )` in clearSelect) is already gone in
3.54.1 and is not part of the behavioural bug.

Failing oracle cases (window9.test):
- window9-8.1.1 `SELECT min(sum(a)) OVER () FROM t1;` -> "misuse of aggregate: sum()" (expected 4)
- window9-8.3 gives a misuse of aggregate error where the expected result differs
