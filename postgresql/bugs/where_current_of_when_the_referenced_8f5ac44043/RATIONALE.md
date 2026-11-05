# Rationale

File/function: src/backend/executor/execCurrent.c, execCurrentOf().
Traces to the execCurrent.c hunk of fix_impl.patch that added the `IsA(scanstate, IndexOnlyScanState)` branch (take the TID from the scan descriptor's xs_heaptid, which is xs_ctup.t_self in the original patch). I removed that branch, so every scan type goes through the generic path. That path reads ctid from the scan slot, and an index-only scan's slot is virtual and has no ctid. WHERE CURRENT OF on an index-only-scan cursor therefore fails with "cursor is not a simply updatable scan" instead of working.

The slot_getsysattr helper changes from the fix are already in the current code, so they were left alone.

Failing oracle case: src/test/regress||portals
