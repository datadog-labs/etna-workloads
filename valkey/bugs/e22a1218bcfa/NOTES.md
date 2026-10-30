Reproducer: master + paused (SIGSTOP) replica, maxmemory set just above current non-replica usage,
allkeys-random, 100 keys of 100KB. Pipes 10000 x 1KB SETRANGE (~10MB) into the master so the
replica output buffer grows.
Clean: replication buffer beyond the backlog is excluded from eviction accounting -> no keys evicted
(prints "no eviction"). Buggy (evict.c lacks that exclusion): buffer counts as used memory, so keys
get evicted (prints "evicted keys", dbsize ~23 vs ~99).
