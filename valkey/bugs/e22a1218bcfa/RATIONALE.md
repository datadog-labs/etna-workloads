# Rationale

fix.patch contains only the merge header (no diff). The fix (redis #5126, "slave buffers were wasteful and incorrectly counted causing eviction") made maxmemory ignore replica output buffers.

## Change
`tree/src/evict.c`, `freeMemoryGetNotCountedMemory()`: removed the block that treats the replication buffer exceeding the backlog (replicas' separate consumption) as not-counted overhead. Replica output buffers are again counted as used memory, so replicas can cause key eviction (the pre-fix behaviour). The AOF buffer and slot-export overhead are untouched.

## Oracle
Fails in tests/unit/maxmemory.tcl: "slave buffer are counted correctly" and "replica buffer don't induce eviction" (keys get evicted because replica buffers count toward maxmemory). Failures were confirmed in check.sh output; the tail I saw showed the replica-buffer test's error trace, and I did not review the full per-case list.
