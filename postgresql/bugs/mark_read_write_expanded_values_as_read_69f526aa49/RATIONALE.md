# Rationale

File: src/backend/executor/execExpr.c, function ExecBuildProjectionInfo.
Traces to the fix_impl.patch hunks in ExecTargetList/ExecProject, which forced projected
values to read-only via MakeExpandedObjectReadOnly. In current code that logic is the choice of
EEOP_ASSIGN_TMP_MAKE_RO for varlena-typed target entries. The change always emits plain
EEOP_ASSIGN_TMP, so read/write expanded datums are no longer marked read-only in projections.
Higher plan nodes referencing the same column twice can then modify the value in place.

Failing oracle case: src/test/regress||plpgsql
