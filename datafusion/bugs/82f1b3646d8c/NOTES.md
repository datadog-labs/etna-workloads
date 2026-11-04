repro.sql sets target_partitions=4 and prefer_hash_join=false, then runs `x NOT IN (subquery containing NULL)`.
Clean: 0 rows, plan uses a null-aware CollectLeft HashJoinExec.
Buggy: planner picks SortMergeJoinExec (not null-aware), so rows 1,3,4 are wrongly returned.
