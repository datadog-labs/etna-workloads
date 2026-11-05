# Rationale

## Changed hunk
- File: src/backend/postmaster/autovacuum.c, function `do_autovacuum()` (work-item loop).
- Traces to the single hunk of fix_impl.patch, which wraps `perform_work_item(workitem)` in
  `PushActiveSnapshot(GetTransactionSnapshot())` / `PopActiveSnapshot()`.
- The change removes the push and the pop. The current code also has an
  `ActiveSnapshotSet()` guard around the pop, and that goes too.
- Without an active snapshot, BRIN autosummarization work items (`brin_summarize_range`) run
  with no snapshot. Index functions that need a snapshot then fail, or the ranges never get summarized.

## Oracle cases that fail
- src/test/modules/brin|t/01_workitems.pl|4 brin_packdate_idx ranges got summarized (missing)

The other three cases still pass.
