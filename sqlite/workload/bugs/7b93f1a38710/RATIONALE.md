# Rationale

Fix: ON-clause validation (`sqlite3SelectCheckOnClauses`) was moved from `sqlite3Select()` into name resolution so it runs before flattening of sub-queries. Before the fix, it ran in `sqlite3Select()` after resolution, so a RIGHT/FULL JOIN inside a sub-query that was flattened never got checked.

## Changes
- `src/resolve.c` (`resolveSelectStep`): removed the `SF_OnToWhere` check/call that was added per compound term. This reverses the fix's `sqlite3ResolveSelectNames` hunk. In 3.54.1 the call lives in the per-term loop instead.
- `src/select.c` (`sqlite3Select`): restored the pre-fix block that calls the check after name resolution, before the `SF_UFSrcCheck` handling, and `goto select_end` on error. This reverses the fix's removal in `sqlite3Select`.
- The `sqlite3SelectCheckOnClauses` rename and prototype are left as is. They are needed so select.c's own call compiles and carry no behaviour.

## Oracle
`joinI-6.5` fails. `SELECT * FROM (SELECT * FROM t7 RIGHT JOIN t8 ON (t6.a) CROSS JOIN t6);` no longer reports "ON clause references tables to its right", because the sub-query is flattened before the check runs. The other 42 cases pass.
