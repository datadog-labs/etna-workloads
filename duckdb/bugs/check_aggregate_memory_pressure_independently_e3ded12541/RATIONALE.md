# Rationale

## Change
File: src/src/execution/radix_partitioned_hashtable.cpp, `RadixPartitionedHashTable::Sink`.

Traces to the fix hunk in `Sink` that replaced the occupancy-only early return with a memory-pressure check:
the fix computed `total_size = ht.GetSizeInBytes()`, called `UpdateSinkReservation`, and set
`memory_pressure = total_size > GetThreadLimit() || state pressure`. The fix skipped the early return and the
grow attempt when `memory_pressure` was true.

Reverted to the pre-fix behaviour:
- `memory_pressure` is now only the aggregate state-arena pressure (`spill_plan && StatePressureExceeded`).
- Sink no longer asks for an extra reservation or checks the thread limit, so the early return depends on pointer-table occupancy alone.
- Growing tables whose rows get wider don't spill until they fill the pointer table.
- An underfull table is no longer given a chance to raise its reservation before being abandoned.

## Oracle results (etna-check)
Only 2 of the 11 units fail:
```
FAIL cpp:test/common/test_radix_ht_sink.cpp::Large aggregate tables spill before their occupancy limit
     test_radix_ht_sink.cpp:154 :: spilled_below_threshold false
FAIL cpp:test/common/test_radix_ht_sink.cpp::Increasing the reservation preserves an underfull aggregate table
     test_radix_ht_sink.cpp:182 :: global.GetThreadLimit() > old_limit 262960 > 262960
```
The other 9 still pass. That includes growth_wide_keys.test_slow, which doesn't catch this revert.
The reason is that the other fix hunks (`PrepareForSpill`, `RetireGrowth`, the OOM catch) are still in place.
