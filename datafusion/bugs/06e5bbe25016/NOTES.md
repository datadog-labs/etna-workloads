Reproducer: LEFT ANTI JOIN of t1 (10000 rows) with t2 (row k=1), ORDER BY t1.k LIMIT 2, plus its EXPLAIN.
Bug: the TopK sort (with fetch) is pushed below the hash join onto the t1 side. Buggy build's plan
shows HashJoinExec fetch: 2 with SortExec(TopK) under it; the clean build keeps TopK above the join.
Plans differ (and the pushdown can give wrong rows since the join filters rows after the limit).
