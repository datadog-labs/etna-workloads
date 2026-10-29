# Rationale

Fix hunk: `impliesNotNullRow()` in src/expr.c gained `case TK_ISNOT:` (plus a testcase) in the group of
operators that prune the walk, so `x IS NOT ?` no longer proves that a column is non-NULL.

Change: in tree/src/expr.c `impliesNotNullRow()`, removed `case TK_ISNOT:` and its testcase from that group.
TK_ISNOT now falls to `default: WRC_Continue`, so the walker descends into `t2.y` and wrongly concludes the
WHERE term implies a non-NULL row of t2. The LEFT JOIN is then wrongly strength-reduced to an inner join.

Oracle failure: join-15.107 (`SELECT *,'x' FROM t1 LEFT JOIN t2 WHERE t2.y IS NOT 'abc'`) returns no rows
instead of the two NULL-extended rows. All other oracle cases pass (1 error out of 199).
