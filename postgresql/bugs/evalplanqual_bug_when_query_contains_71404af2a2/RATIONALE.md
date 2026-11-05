# Rationale

## src/backend/executor/nodeLockRows.c, ExecLockRows()
Traces to the nodeLockRows.c hunk of fix.patch. The fix removed the code that
assigned NULL test tuples to every relation of the query when setting up EPQ.
The reverse re-adds that behaviour in the current slot-based EPQ API. After
EvalPlanQualBegin(), a loop over lr_epqstate.arowMarks (the non-locking
rowmarks, i.e. relations LockRows does not lock) creates and clears an EPQ
slot for each. ExecScanFetchExtended then finds relsubs_slot[] set and returns
an empty test tuple, instead of fetching the real row through the non-locking
rowmark. Unlocked tables therefore return NULLs during the recheck, which is
bug #14034.

## Failing oracle cases
- src/test/isolation||eval-plan-qual
