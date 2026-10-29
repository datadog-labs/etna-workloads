# Rationale

Fix c113e31b made seriesFilter() in ext/misc/series.c handle a REAL right-hand
side on `value` constraints (=, >, >=, <, <=). In 3.54.1 that logic has been
extended with range clamping and seriesCeil/seriesFloor helpers, so the hunks
can't be reversed literally.

I removed the `sqlite3_value_numeric_type(...)==SQLITE_FLOAT` branches in all
three places the fix added them, leaving the pre-fix code that calls
`sqlite3_value_int64()` and then applies `iMin++` / `iMax--`:

- `value=X`: fix hunk 1 (float branch with r==ceil(r) else no rows). Without it, 5.5 truncates to 5 and `value==5.5` returns 5.
- `value>X` / `value>=X`: fix hunk 2 (ceil, +1 only for integral r). Reverted to int64 truncation.
- `value<X` / `value<=X`: fix hunk 3 (floor, -1 only for integral r). Reverted to int64 truncation, so `value<5.5` yields iMax=4.

The seriesCeil/seriesFloor/seriesRealToI64 helpers are now unused by this
code (left in place).

## Oracle failures
tabfunc01-6.1 (`value<5.5` gives 1..4), 6.7 (`value>=5.5`), 6.9, 6.15, 6.17
(`value==5.5` returns 5) — the tests the fix added. Also 1302, 1320, 1321,
1523, large-value cases that rely on the float path's range clamping.
