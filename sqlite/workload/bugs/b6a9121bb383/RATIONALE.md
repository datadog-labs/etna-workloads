# Rationale

Fix: add `case TK_BITNOT:` to the prune list in `impliesNotNullRow()` (src/expr.c), so `~(x AND FALSE)` is not assumed to imply a non-null row.

In 3.54.1 neither TK_NOT nor TK_BITNOT is in that list: AND now uses `bothImplyNotNullRow()`, which already covers `NOT(...)` and `~(...)`. Adding TK_BITNOT alone therefore changes nothing, so I restored the 2019 pre-fix state in `impliesNotNullRow()`:

1. Re-added `case TK_NOT:` (and its testcase) to the prune list, as the code was when the fix landed. It has TK_NOT but not TK_BITNOT, which is the omission the fix corrected.
2. Split `TK_AND` out of the `TK_OR`/`TK_AND` case. Only OR still uses `bothImplyNotNullRow()`. AND falls through to default `WRC_Continue`, so either operand implying non-null-row is enough. This is correct under plain WHERE and under NOT, which is pruned. It is wrong under `~`, because BITNOT is not pruned.

Result: `~('x'='y' AND t2.y=1)` wrongly marks t2 non-null-row, so the LEFT JOIN is turned into an inner join.

Oracle: join-15.106b (`WHERE ~('x'='y' AND t2.y=1)` on a LEFT JOIN) fails. It is the only failure, 1 of 199 tests. The rows with NULL t2 columns are lost.
