Reproducer: EXPLAIN of an IN-subquery semi-join with ORDER BY c DESC, target_partitions=2, from the upstream joins.slt test.
The plans differ: clean sorts the HashJoin's right child by c@2 DESC (sort pushed down); buggy shows SortExec b@1 DESC on that side, so the plan differs. Query results are identical.
