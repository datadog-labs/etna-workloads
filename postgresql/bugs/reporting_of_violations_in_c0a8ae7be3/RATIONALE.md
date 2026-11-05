# Rationale

Changed file: src/backend/executor/execMain.c

1. `ExecConstraints` (check-constraint failure branch) and
2. `ReportNotNullViolationError` (not-null failure; in the original patch this code lived inline in ExecConstraints)

Both trace to the fix.patch hunks in `ExecConstraints` that, after tuple routing, convert the
partition-rowtype tuple back to the root table's rowtype (convert_tuples_by_name / do_convert_tuple)
before calling ExecBuildSlotValueDescription with the root's tupdesc. In current code that conversion is
`slot = execute_attr_map_slot(map, slot, MakeTupleTableSlot(...))`; I removed it in both places. The
partition-rowtype slot is then interpreted with the root's tupdesc, so "Failing row contains ..." shows
wrong/misordered columns when the partition's column layout differs from the root's.

Failing oracle case: src/test/regress||insert
