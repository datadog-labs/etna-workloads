Master (AOF, fsync always) + one replica without AOF, SIGSTOPped. Client B does `incr`, `waitaof 0 1 3000`
(blocks, older offset); client A then does `incr`, `wait 1 0` (blocks, newer offset; blocked clients are
processed newest first). Replica is resumed.
Clean: WAIT returns 1; WAITAOF times out with `1 0` (replica never acks AOF fsync).
Buggy: WAITAOF reuses WAIT's cached last_offset/last_numreplicas and is wrongly unblocked with `1 1`.
