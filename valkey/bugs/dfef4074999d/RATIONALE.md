# RATIONALE

Fix (PR #7029): XACK must be "all or nothing". The fix parses all IDs first, then acks.

Changed: `xackCommand` in `src/t_stream.c`. Reverted to the pre-fix single loop that parses each ID
and acknowledges it immediately, returning on a parse error (`return;`). IDs acked before the invalid
one stay removed from the PELs (and `server.dirty` is bumped) while an error is returned.
The `static_ids`/`ids` pre-parse vector and the `cleanup:` label were removed.

Oracle failure: `XACK should fail if got at least one invalid ID` in tests/unit/type/stream-cgroups.tcl.
After `XACK s g id1 invalid` errors, `XACK s g id1` returns 0 instead of 1 because id1 was already acked.
