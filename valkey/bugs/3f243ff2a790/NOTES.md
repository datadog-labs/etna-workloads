Starts two cluster nodes (A: slots 0-8191, B: 8192-16383), writes 100 keys into slot 16287 on B,
then runs CLUSTER MIGRATESLOTS to move that slot to A and prints DBSIZE on both nodes.

Clean: A dbsize is 100. Buggy: A dbsize is 200, because setSlotImportingStateInAllDbs is called twice
and the key count is added to the kvstore twice (COUNTKEYSINSLOT stays correct at 100).
