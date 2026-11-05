# Rationale
- File/function: src/backend/tcop/pquery.c, DoPortalRewind. Traces to the sole hunk of fix_impl.patch.
- Removed the PushActiveSnapshot(queryDesc->snapshot)/PopActiveSnapshot() pair around ExecutorRewind(), so rewinding a cursor runs without an ActiveSnapshot. That brings back the bug.

Failing oracle case: src/test/regress||portals
