# Rationale

Hunk 1 — `src/common/serializer/async_memory_governor.cpp`, `ManagedAsyncMemoryGovernor` constructor.
Traces to the fix's change of the same function. I removed the `max_memory` lookup and the `MinValue(..., max_memory / DIVISOR)` clamps. `max_pending_bytes` and `min_pending_bytes` are again purely per-thread (64MB/8MB × threads), so the backlog budget is no longer bounded by the memory limit.

Hunk 2 — same file, include. I removed `#include "duckdb/storage/buffer_manager.hpp"`, which the fix added and which is no longer used.

I left the header's new constants (`*_MEMORY_LIMIT_DIVISOR`) in place and unused, to avoid a long header rebuild.

## Oracle result (`./bin/etna-check`)
```
PASS     batch_memory_usage.test_slow
PASS     batch_memory_usage_small.test_slow
FAIL     read_ahead_memory_limit.test_slow
         Query unexpectedly failed! (read_ahead_memory_limit.test_slow:30)
         Out of Memory Error: failed to allocat...
1 of 3 oracle units fail
```
With threads=16 and memory_limit=150MB, the default read-ahead now reserves more than the limit allows, giving an OOM. The two batch_memory_usage tests still pass.
