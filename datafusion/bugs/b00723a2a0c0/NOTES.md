repro.sql creates two empty tables and EXPLAINs a nested-loop join and a hash join (with a filter), each ordered by a right-side column.
Clean build pushes the SortExec down into the join's right child. The buggy build leaves the SortExec above the join (HashJoinExec pushdown is blocked and the custom pushdown is missing), so the physical plans differ.
