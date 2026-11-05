# Rationale

File/function: src/backend/executor/execMain.c, ExecPartitionCheckEmitError (modern home of the partition-constraint error reporting in ExecConstraints).

Traces to the fix.patch hunk in ExecConstraints that, for a routed tuple (ri_PartitionRoot, now ri_RootResultRelInfo), switches to the root relation/tupdesc and reports the original (root-rowtype) slot in "Failing row contains ...". I removed the conversion back to the root rowtype (reverse attr map, root relid/tupdesc, root modified cols). The error now describes the partition-rowtype tuple using the partition's own relid/descriptor, as before the fix. When a partition's column order differs from the root's, the failing-row detail is wrong (it is not the input row).

Failing oracle case: src/test/regress||insert
