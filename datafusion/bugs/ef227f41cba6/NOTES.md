repro.sql runs CUBE/ROLLUP grouping sets over a column containing NULLs, with target_partitions=4.
Clean: the NULL group from the data and the grand-total NULL group are separate rows (e.g. NULL,2 and NULL,6 for count).
Buggy: the final aggregation drops the grouping id, so the two NULL groups merge into one (NULL,8; min gives NULL,1).
