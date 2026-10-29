# Rationale

In 3.54.1 the fix is still present in `src/resolve.c` (`case TK_ISNULL/TK_NOTNULL` in `resolveExprStep`).
The bug was reintroduced by deleting the loop that returns `WRC_Prune` unless every
NameContext has `NC_Where` set. This reverses the fix hunk that added that "only in the WHERE clause"
check. The pre-fix code applied the NOT NULL strength reduction wherever the operand could not be NULL.
The later refactoring in the fix (TREETRACE, reordered code) is behavior-neutral, so it was left alone.
The `NC_Where` definition and the set/clear in `resolveSelectStep` are left as harmless unused flags.

## Oracle failure
`notnull2-5.0`: `CREATE TABLE t1(a INT NOT NULL); SELECT a IS NULL, a IS NOT NULL, count(*) FROM t1;`
returns `0 1 0` instead of `1 0 0`. The bare column of the empty aggregate is NULL, but
`a IS NULL` was folded to constant 0 because of the column's NOT NULL attribute.
