repro.sql builds the cost-1.1 schema (t3 with a NOT NULL column and unique index, t4 with unique index i4(c,d)) and runs EXPLAIN QUERY PLAN on `SELECT e FROM t3, t4 WHERE b=c ORDER BY b, d`.

Clean: scans t3 via covering index i3 and searches t4 by i4 (c=?), so no sorter is needed.
Buggy: the sort cost is underestimated, so the planner scans t4, searches t3 and adds `USE TEMP B-TREE FOR ORDER BY`.
