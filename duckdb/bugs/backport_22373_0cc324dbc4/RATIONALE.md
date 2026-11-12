# Rationale
All hunks in src/execution/operator/aggregate/physical_window.cpp, reverting the fix:
- WindowGroupState::TryPrepareNextStage (SINK case): gate on `sunk == count` (rows) instead of `sunk == blocks`.
- `sunk` comment: counts rows again.
- WindowLocalSourceState::Sink: removed `task_blocks` and the block-based increments (early return when no scanner, and end of task); restored per-chunk `sunk += input_chunk.size()`.
Empty-block SINK tasks no longer count, so FINALIZE can start before they initialise thread_states -> index out of range.
Oracle: test/sql/window/test_window_finalize_race.test expected to fail (see etna-check output below).

## etna-check result
```
INTERNAL Error: Attempted to access index 0 within vector of size 0
1 of 1 oracle units fail
```
test/sql/window/test_window_finalize_race.test fails with the original crash.
