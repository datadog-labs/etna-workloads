# Rationale

## Changed hunk
- File: src/backend/replication/logical/worker.c, function `apply_handle_update`.
- Traces to the `apply_handle_update` hunk of fix.patch (the updatedCols loop).
- The fix maps each local attribute to its remote attribute number via `rel->attrmap->attnums[i]`. It skips dropped and subscriber-only columns, and checks `colstatus[remoteattnum]`.
- The change restores the old code. It indexes `newtup.colstatus[i]` directly by the local attribute number and drops the attrmap lookup and the bounds check. When local and remote column orders differ, or the subscriber has extra columns, the wrong columns end up in `updatedCols`. Column triggers then misfire, or the loop reads past the end of `colstatus`.
- The current code uses a runtime `ereport` where the original fix had an `Assert` on `ncols`. I removed it together with the loop's mapping, because it only makes sense with the mapping. The `ncols` field itself is left in place.

## Failing oracle cases
- src/test/subscription|t/003_constraints.pl|check column trigger applied even on update for other column
- src/test/subscription|t/003_constraints.pl|check replica update column trigger applied on subscriber
