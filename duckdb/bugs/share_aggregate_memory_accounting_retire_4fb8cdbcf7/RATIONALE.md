# Rationale

Hunk: src/src/common/types/row/tuple_data_allocator.cpp, TupleDataAllocator::Reset.
Traces to the fix's first hunk, which added `block_allocation_size = 0;` in Reset().
I removed that line. Reset() now drops row_blocks/heap_blocks but leaves the cached
allocation size stale, so GetBlockAllocationSize() reports memory for blocks that no longer exist.
This is the accounting bug the fix addressed (cached size not following retained blocks).

Expected failing oracle unit: test_tuple_data_allocation.cpp (second.Reset() must yield 0).

Result (etna-check output):
build ok; running oracle tests ...
PASS     cpp:test/common/test_aggregate_hll.cpp::Aggregate HLL observes every distinct hash across lookup hits and reuse
PASS     cpp:test/common/test_aggregate_hll.cpp::Aggregate lookup recovery resets dictionary caches and preserves observation across reuse
FAIL     cpp:test/common/test_tuple_data_allocation.cpp::Tuple data allocation accounting follows retained blocks
         test/common/test_tuple_data_allocation.cpp:48 :: second.GetBlockAllocationSize() == 0 8912896 (0x880000) == 0 

1 of 3 oracle units fail
done

The two HLL oracle units still pass: the HLL hunks of the fix were already refactored (adaptivity.ObserveHashes) and a faithful revert there was not observably failing.
