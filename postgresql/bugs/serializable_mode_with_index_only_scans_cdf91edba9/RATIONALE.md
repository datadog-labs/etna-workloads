# Rationale

## src/backend/executor/nodeIndexonlyscan.c, IndexOnlyNext()
Traces to the fix.patch hunk that adds the `PredicateLockPage()` call (and the `predicate.h` include / `tuple` variable) in IndexOnlyNext. In current code this is the `if (!tuple_from_heap) PredicateLockPage(...)` block before `return slot;`. I removed it, so index-only scans that skip the heap fetch (all-visible pages) take no predicate lock. Serializable mode then misses rw-conflicts with concurrent writers, so write skew anomalies go undetected.

## Failing oracle cases
- src/test/isolation||index-only-scan
