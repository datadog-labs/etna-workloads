# Rationale

Changed: src/backend/executor/execMain.c, three hunks (the current code already has ExecGetInsertedCols/UpdatedCols
mapping, so the old pre-fix state is re-expressed by choosing the wrong ResultRelInfo):
- ExecPartitionCheckEmitError, ExecConstraints (NOT NULL case), ExecConstraints (CHECK case): `modifiedCols` is computed
  from `resultRelInfo` (the partition; columns mapped to partition attnums) instead of `rootrel`, though the slot has
  been converted back to the root's rowtype and root descriptor is used. This traces to the fix.patch hunks in
  execMain.c that compute modifiedCols from the root rel's inserted/updated columns when ri_RootResultRelInfo is set.
  Result: column-permission checks in ExecBuildSlotValueDescription use mismatched attnums, so values of columns
  the user lacks privilege on can leak (or permitted ones be hidden) in partition constraint-violation errors.

Failing oracle case: src/test/regress||privileges
