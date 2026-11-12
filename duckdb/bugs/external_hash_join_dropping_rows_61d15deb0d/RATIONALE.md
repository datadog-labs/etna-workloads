# Rationale

The upstream fix added `JoinHashTable::BuildBloomFilterFromSinkCollection()`. That function no longer exists in
this tree. Today's code builds the external-join Bloom filter during Sink, so it covers every round. I re-created
the original bug by removing that mechanism, using two hunks in `src/execution/operator/join/physical_hash_join.cpp`:

1. `HashJoinGlobalSinkState::InitializeBloomFilter`: the condition is now `if (true || ...)`, so the sink-accumulated
   Bloom filter is never created. This undoes the "build from the whole build side" safeguard that the fix
   restores.
2. `JoinFilterPushdownInfo::FinalizeFilters`: `else if (allow_prefix_range_filters)` became `else`. An external
   join, which passes `allow_prefix_range_filters=false`, now falls into the finalize-built Bloom filter path.
   That filter is built only from the partitions of round 1 and is published after that round. Probe rows whose
   key is in a later round's partitions are then dropped.

## Oracle result
```
FAIL     test/sql/outofcore/out_of_core_hash_join_bloom_filter_pushdown.test_slow
         Wrong result in query! (...test_slow:27)!
         SELECT count(*) FROM t WHERE a IN (SELECT b FROM u);
         480000 <> 3000000
1 of 1 oracle units fail
```
