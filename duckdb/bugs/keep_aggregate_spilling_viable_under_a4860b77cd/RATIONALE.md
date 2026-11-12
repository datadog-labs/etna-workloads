# Rationale

Hunks (the fix's code exists in slightly different form in v2.0.0; `tuple_size_count` is `tuple_size_cache.count`):

1. `src/execution/radix_partitioned_hashtable.cpp`, `RadixHTLocalSinkState::PrepareForSpill`: removed the
   try/catch around `ht->Resize(sink_capacity)` (fix hunk 2). An OutOfMemoryException during the optional
   shrink now propagates instead of retaining the existing pointer table.
2. `src/execution/aggregate_hashtable.cpp`, `ResetForNewIteration`: removed `tuple_size_cache.count.SetInvalid()`
   (fix hunk 1d). The cached tuple size is then stale after iteration reuse when the materialized count is unchanged.

Oracle results (etna-check): 2 of 10 oracle units fail.

FAIL ...::Spilling tolerates memory pressure while shrinking retained pointer allocations
  test_radix_ht_sink.cpp:395 fixture.Sink() -> Out of Memory "failed to allocate data of size 256.0 KiB (122.0 MiB/122.0 MiB used)"
FAIL ...::Aggregate memory accounting tracks hits and replacement tuple storage
  test_radix_ht_sink.cpp:436 narrow_size < wide_size  3411968 < 3411968

The other 8 units pass (they are not sensitive to these hunks).
