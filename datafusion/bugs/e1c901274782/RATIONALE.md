# Rationale

Fix: wrap the sort's output stream in `ObservedStream` so output_batches/output_bytes/end_time
are recorded when the output does not go through the `StreamingMergeBuilder`.
55.2.0 already contained the fix; I removed it again (pre-fix behaviour).

## sort.rs (ExternalSorter)
- `in_mem_sort_stream(is_output_stream, ..)` -> back to taking `metrics: BaselineMetrics`; callers pass
  `baseline.clone()` (output) / `baseline.intermediate()` (spill), and the merge builder uses `metrics`.
- Removed `observe_if_output` and its uses (empty, single-batch and concat in-place paths return the
  unwrapped stream), so no `ObservedStream` wraps these outputs.
- `sort_batch_stream` takes `metrics` again and counts `output_rows` through a `.map`, as before the fix.
  This is the only metric the pre-fix code recorded on these paths.

## multi_level_merge.rs
- Removed `observe_output` and the wrapping in the (0,0), (0,1), (1,0) arms, and the unused import.

## Oracle
`explain_analyze.slt` fails: SortExec reports `output_bytes=0.0 B` instead of 60.0 B / 32.0 B
(also output_batches / end_time unrecorded) for an in-memory sort.
