# Rationale

One hunk changed: `streamTrim()` in `tree/src/t_stream.c`.

The fix moved the LIMIT check from the top of the loop (`limit && deleted >= limit`, run before the node's entry count is read) to after `entries` is read (`limit && (deleted + entries) > limit`). I put it back at the top of the loop in its original form. The `MAXLEN` break stays after it, as it was before the fix. With the old check, trimming only stops once the limit has already been reached. So a whole node can be deleted even when it holds more entries than the remaining budget. That deletes at least LIMIT entries rather than at most LIMIT.

Oracle cases that fail:
- `XADD with LIMIT delete entries no more than limit`: XLEN is not 4.
- `XTRIM with LIMIT delete entries no more than limit`: `XTRIM mystream MAXLEN ~ 0 LIMIT 1` deletes a node of 2 entries instead of returning 0.
