Joins two tables on a Binary column and runs EXPLAIN plus the join itself.
Clean build plans a HashJoinExec. The buggy build's `can_hash` rejects Binary, so it plans a different join (not a hash join). The EXPLAIN output differs.
