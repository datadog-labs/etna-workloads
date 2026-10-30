# Rationale

## src/tracking.c, trackingInvalidateKey()
Reverses the single implementation hunk of the fix: the NOLOOP check compares
`target == c` again instead of `target == server.current_client`. When a script
runs, `c` is the script's fake client, not the real caller, so a NOLOOP client's
own writes from scripts are no longer skipped and an invalidation is sent anyway.

## Oracle failures
- "Invalid keys should not be tracked for scripts in NOLOOP mode": the GET after the
  script's SET returns `invalidate key1` push instead of `2`.
- "Tracking info is correct": fails as a knock-on effect (a tracking client count
  mismatch, 3 vs 2), probably from state left behind by the previous failing test.
