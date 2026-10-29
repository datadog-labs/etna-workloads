`repro.sql` references a window-function alias (`m`) from a sub-select in ORDER BY.

- clean: `misuse of aliased window function m` (exit 1).
- buggy: the alias check skips the `pNC!=pTopNC` case, so the query is accepted and hits an assertion failure in sqlite3VdbeExec (`memIsValid(pRec)`, abort).
