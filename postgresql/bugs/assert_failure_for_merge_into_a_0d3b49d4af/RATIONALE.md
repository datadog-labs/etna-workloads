# Rationale

File: src/backend/executor/execPartition.c, function ExecInitPartitionInfo.
Traces to the fix.patch hunk that adds the `CMD_MERGE` branch to the Assert in the
WITH CHECK OPTION block. I removed that branch again, so the Assert only accepts INSERT and UPDATE.
MERGE into a partitioned table with RLS (WCO lists, one per result rel) now trips the Assert
when a partition is initialised for tuple routing.

Failing oracle case: src/test/regress||merge
