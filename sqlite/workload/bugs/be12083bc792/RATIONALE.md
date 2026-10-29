# Rationale

Bug: CTEs referenced from sub-selects in window PARTITION BY / ORDER BY were not visible,
and RENAME COLUMN resolved window definitions too early.

## Changes
- `src/walker.c` (sqlite3WalkSelectExpr): removed the `xSelectCallback2==sqlite3SelectPopWith`
  condition added by the fix, so window definitions are not walked during CTE/FROM expansion
  (selectExpander), and sub-selects in them never get CTE names resolved.
  `sqlite3SelectPopWith` itself (renamed from the static `selectPopWith`) is left, as it is
  only a rename and is still used by `sqlite3SelectExpand`.
- `src/resolve.c` (resolveSelectStep): moved the `IN_RENAME_OBJECT` window PARTITION/ORDER BY
  name-resolution block back from before ORDER BY/GROUP BY resolution to after GROUP BY,
  reversing the fix's move hunk.

## Oracle failures
- window8-8.4 fails with `no such table: map2` (CTE referenced from a subselect in a named
  WINDOW's PARTITION BY).
