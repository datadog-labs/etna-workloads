# Rationale

Hunk reversed: `src/build.c` `sqlite3EndTable()` (fix hunks 1 and 2 in build.c).
The fix moved column-name generation (`sqlite3ResultSetOfSelect()`) before
`sqlite3Select()` for CREATE TABLE AS. In 3.54.1 that ordering still exists, so
I restored the pre-fix order: the coroutine is generated with `sqlite3Select()`
first (followed by `EndCoroutine`/`JumpHere` and the `nErr` check), and only
then is `sqlite3ResultSetOfSelect()` called to build the new table's columns.
`sqlite3Select()` rewrites the SELECT (subquery flattening, so `Bbb` alias
becomes the underlying `aaa`), so the names come out wrong.

The select.c hunks (asserts/TK_AGG_COLUMN) are not behavioural and were not reverted.

Oracle failures (test/colname.test):
- colname-9.320: expected `Bbb`, got `aaa` (inconsistent CREATE TABLE AS column name).
- colname-10.110: expected `with space`, got `"with space"` (quoted name leaks into CTAS column).
