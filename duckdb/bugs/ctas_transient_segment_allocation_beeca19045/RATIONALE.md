# Rationale

## Hunk changed
`src/storage/table/row_group.cpp`, `RowGroup::InitializeAppendInternal`: the
`if (!transient) { transient = make_uniq<SuballocationBlock>(); }` was changed to an
unconditional `transient = make_uniq<SuballocationBlock>();`.

Traces to the fix's hunk in the same function (`if (!transient) transient = make_uniq...`
with `state.transient = transient.get()`). Before the fix, the suballocation block lived in
the per-call `RowGroupAppendState` and so was fresh for every new append state. Resetting it
on every InitializeAppend restores that behaviour: suballocation state does not survive
append-state recreation within a row group, so each new append state allocates fresh
transient blocks and wastes the remainder of the old ones.

Deviation: today's code has the `transient` member on RowGroup (and a handoff in
`InitializeNextAppend`) in a form that already differs from the fix's parent. To avoid a
40+ minute header rebuild, I did not move the member back into `RowGroupAppendState`; the
resetting in the .cpp gives the same observable behaviour. The `RevertAppend` hunk was not
reverted, so the rollback test still passes.

## Oracle results
```
FAIL     test/sql/storage/adaptive_segment_allocation.test
         Invalid Input Error: expected < 8000000 bytes, got 13901480
PASS     test/sql/storage/adaptive_segment_rollback.test
FAIL     test/sql/storage/temp_directory/ctas_adaptive_segments.test_slow
         Out of Memory Error: failed to offload data block of size 256.0 KiB (45.6 MiB/45.7 MiB used).
2 of 3 oracle units fail
```
