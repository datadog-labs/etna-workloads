Reproducer (`repro.sql`): scalar subquery over a compound SELECT, e.g.
`SELECT (SELECT 1 FROM t1 WHERE a=1 UNION ALL SELECT 2 FROM t1 WHERE b=4)`
(cases tkt1473-2.4/2.5).

Clean shell returns 1 for both queries (the scalar subquery has an implicit
LIMIT 1). The buggy shell returns 2: the injected patch drops the "jump ahead
if LIMIT reached" check in the compound-select code, so later arms still run
after the limit is hit and their row overwrites the result.
