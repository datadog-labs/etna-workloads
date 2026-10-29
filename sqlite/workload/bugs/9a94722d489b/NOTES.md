repro.sql: windowed min()/max() with PARTITION BY and a frame that does not start at
UNBOUNDED PRECEDING (ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) over 9 rows in 3 partitions.
The clean shell resets the min/max sorter at each partition start, so results are correct
(1|1, 2|2, 3|3, 2|1, ...). The buggy shell drops the OP_ResetSorter, so values from earlier
partitions leak in (e.g. row 2 gives 3|2 instead of 2|2; min stuck at 2). Exit status is 0 in both.
