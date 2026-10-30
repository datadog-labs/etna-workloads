Chains primary -> replica (dual-channel, primary protects the replica's RDB channel client), then makes the primary a replica of a new server.
Clean: the primary disconnects its replicas, resyncs, and the chain converges (prints `synced`).
Buggy: disconnectReplicas() doesn't unprotect the RDB channel, so freeReplicationBacklog hits `ASSERTION FAILED` and the primary crashes (`primary dead`, `ASSERTION`, `not synced`).
