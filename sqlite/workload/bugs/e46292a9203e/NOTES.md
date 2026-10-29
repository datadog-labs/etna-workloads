Reproducer (repro.sql): a CTE that is a UNION ALL of two selects from the UPDATE target t1 is
used in `UPDATE t1 SET (a,a) = (SELECT 1,0) FROM t3`. The echo vtab module from vtab1-25.0 is
not in the shell, but the failure does not depend on it; a plain table triggers it.

Clean shell: statement runs, no output, exit 0. Buggy shell (injection removes the
`p->selFlags &= ~SF_UFSrcCheck` clearing in select.c): "Parse error near line 2: target
object/alias may not appear in FROM clause: t1", exit 1.
