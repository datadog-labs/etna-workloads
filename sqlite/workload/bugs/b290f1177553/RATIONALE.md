# Rationale

Fix: dan's 2014-01-17 commit moved the WITH-stack pop from right after
`selectExpander()` (wrapper `selectExpanderWith`, called before the walk of
subqueries) to an `xSelectCallback2` (`selectPopWith`) that runs after the
subqueries are walked. Before the fix, a WITH clause was popped before
sub-queries in expressions/FROM were expanded, so they could not resolve CTE names.

## Change (src/select.c only)
- Reintroduced `selectExpanderWith()`: calls `selectExpander()` and then
  immediately pops `p->pWith` off `pParse->pWith`. Reverses the fix hunk that
  deleted `selectExpanderWith` and added `selectPopWith`.
- `sqlite3SelectExpand()` uses `selectExpanderWith` as `xSelectCallback` and sets
  `xSelectCallback2 = 0` (reverses the hunk setting `xSelectCallback2 = selectPopWith`).
  `sqlite3SelectPopWith` remains defined but unused.

The 3.54.1 push (`sqlite3WithPush(pParse, p->pWith, 0)` inside selectExpander)
is kept, as in the fix; the other hunks (bFreeWith, parse.y, walker) were
refactored beyond reversal and are not needed to recreate the bug.

## Oracle failures (test/with2.test)
with2-1.2, 1.3 (scalar subquery referencing CTE: "no such table"), 1.4, 1.9,
1.10, 7.3, 7.4, 10.1 fail with "no such table: x1/ss/t1".
