# Rationale

File: src/src/common/vector_operations/comparison_operators.cpp, `ListOrArrayComparator`.

Today's code has a single scatter call in this function and no `active_count` variable (the compacted count is stored back into `remaining_count`). The fix's hunks all pass `active_count` (the count after `ListOrArrayExhausted`) to `NestedScatter`. I undid that by saving `pre_exhausted_count = remaining_count` before the `ListOrArrayExhausted` call. I pass that count to `NestedScatter`, so it scatters more entries than were compared. That reads stale selection indices and uninitialised `child_result` slots, as before the fix.

The other hunks (`SetAllValid(active_count)` and the two other `NestedScatter` calls) belong to code paths that don't exist in this form in today's tree. The struct and union call sites are unchanged, as in the fix.

Oracle result:
```
test/sql/types/nested/list/list_comparison_stale_positions.test:15
Mismatch on row 3 ... 0 <> true
1 of 1 oracle units fail
```
