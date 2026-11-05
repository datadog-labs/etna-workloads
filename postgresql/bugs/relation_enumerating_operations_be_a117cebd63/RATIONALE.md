# Rationale

Changed hunk: `src/backend/commands/cluster.c`, `cluster_rel()`.
Traces to the cluster.c hunk of fix.patch ("Switch to the table owner's userid ... SECURITY_RESTRICTED_OPERATION" added after opening OldHeap).
I removed the `SetUserIdAndSecContext(OldHeap->rd_rel->relowner, ... | SECURITY_RESTRICTED_OPERATION)` call. CLUSTER and VACUUM FULL then run index expressions and predicates as the calling user, not the table owner, and without the security restriction. That is the original bug.

Failing oracle case: src/test/regress||privileges (the sro_ifun current_user assertion fails during CLUSTER).
