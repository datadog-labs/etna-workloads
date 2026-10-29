# Rationale

Fix (ticket #2251) made the GROUP BY sorter-population code in sqlite3Select
use the new shared sqlite3ExprCodeGetColumn(), which expands ALTER TABLE
default values (sqlite3ColumnDefault) and adds OP_RealAffinity for REAL
columns. Before, it emitted a bare OP_Column / OP_Rowid.

In 3.54.1 the shared helper is sqlite3ExprCodeGetColumnOfTable() (expr.c),
which still does both, so the fix hunks cannot be reversed literally.

## Change (src/select.c, sorter loop in sqlite3Select)
Reverses the select.c hunk: for an ordinary rowid-table, non-virtual,
non-generated, non-rowid column, emit a raw `OP_Column` (with storage-column
mapping) instead of going through sqlite3ExprCode(). No default expansion and
no OP_RealAffinity, exactly the pre-fix behaviour. Other column kinds use the
existing path. The expr.c refactor hunk is not reversed (the helper is
shared with many other callers and is correct).

## Oracle failures
- alter-8.2: `SELECT a, sum(b) FROM t2 GROUP BY a` after ADD COLUMN ... DEFAULT 9
  sums NULLs instead of the default, giving the wrong result.
- Without the read-side RealAffinity at expr.c (TK_AGG_COLUMN useSortingIdx),
  select3-8.2 (typeof(sum) should be real) also fails; that code was added
  later and masks the REAL half of the bug, so I left it untouched.
