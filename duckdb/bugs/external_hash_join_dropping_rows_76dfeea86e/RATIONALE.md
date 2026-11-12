# Rationale

Today's code differs from the upstream parent: the sink-built, sealed bloom filter already exists. The original
bug was an external join publishing a bloom filter built from only the materialized partitions. That path still
exists as the "finalize-built bloom filter" fallback in FinalizeFilters, but it is gated to in-memory joins.

## Hunk: src/execution/operator/join/physical_hash_join.cpp, JoinFilterPushdownInfo::FinalizeFilters
Traces to the fix hunk that removed `ht->SetBuildBloomFilter(true)` / finalize-built bloom filters for the
external path (and the `PrepareBloomFilterForFinalize` calls in the external finalize). I changed
`} else if (allow_prefix_range_filters) {` to `} else {`. When no complete sink-built filter is publishable,
the external finalize (which calls FinalizeFilters with allow_prefix_range_filters=false) now defers a
finalize-built bloom filter. An external finalize only materializes some partitions, so that filter holds only
part of the build keys and rejects matching probe rows.

(Rejected first attempt: passing allow_prefix_range_filters=true from FinalizeExternalRuntimeFilters. It made the
test fail with an unrelated prefix-range assertion, so I reverted it.)

## Oracle result
```
FAIL     test/sql/join/external/external_join_runtime_filter.test
         test/sql/join/external/external_join_runtime_filter.test:47
         Mismatch on row 1, column count_star()(index 1)
         26292 <> 400000
1 of 1 oracle units fail
exit=0
```
