# Rationale

Changed: src/src/backend/executor/execReplication.c, `build_replindex_scan_key()`.
Traces to the sole fix_impl.patch hunk, which widened the Assert to also accept the primary key index.
I re-added the old narrow `Assert(RelationGetReplicaIndex(rel) == RelationGetRelid(idxrel));`.
With REPLICA IDENTITY FULL on the subscriber, the PK index can be chosen for the scan, so the index is not the replica index and the assertion fails, crashing the apply worker (assert-enabled build).

Failing oracle cases: 25/38, all in src/test/subscription t/001_rep_changes.pl (the apply worker crashes at the REPLICA IDENTITY FULL + primary key update, and later cases are missing). Examples: "update works with REPLICA IDENTITY FULL and a primary key", "update target row is missing", "delete target row is missing", "empty transaction is skipped", and "check subscription was dropped on subscriber".
