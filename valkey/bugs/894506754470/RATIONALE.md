# Rationale

Fix hunk: `delKeysInSlot()` in cluster.c gained `propagateDeletion(...)` (+ propagatePendingCommands, signalModifiedKey, module notify, dirty++), so deletes of keys in a slot lost to another master replicate to replicas.

In 9.0.7 the function lives in `src/cluster_legacy.c`; signalModifiedKey, module notification and `server.dirty++` are still present. The replication piece is `if (propagate_del) propagateDeletion(db, key, lazy, hashslot);` (propagatePendingCommands became postExecutionUnitOperations). I removed that line (and its comment), restoring the pre-fix behaviour: keys are deleted locally on the old master but the DEL is never propagated, so replicas diverge.

Oracle failure: "Verify that slot ownership transfer through gossip propagates deletes to replicas" fails (replica countkeysinslot never reaches 0). The other 3 cases still pass.
