# Rationale

## Change: src/expr.c, sqlite3ExprCollSeq()
Reverses the fix's `sqlite3ExprCollSeq` hunk. The fix made the `EP_Collate`
walk look through `Expr.x.pList` (function args, CASE lists, etc.) when
`pLeft` carries no collation. I restored the pre-fix walk: `p = p->pRight`
when `pLeft` has no `EP_Collate`. COLLATE therefore no longer propagates
upward through function calls or CASE. The flag propagation in
`exprSetHeight` (the other fix hunk) still sets `EP_Collate`, but nothing
follows it into the list. Reversing that hunk directly doesn't work
because `EP_Propagate` now also carries `EP_Subquery` and `EP_HasFunc`.

## Oracle failures (test/collate8.test)
- collate8-3.1: `'abc'==('ABC'||upper('' COLLATE nocase))` gives 0, expected 1.
- collate8-3.2: `max('' COLLATE nocase,'' COLLATE binary)` gives 0, expected 1.
- collate8-3.4: CASE with COLLATE nocase branches gives `0 0`, expected `1 1`.
