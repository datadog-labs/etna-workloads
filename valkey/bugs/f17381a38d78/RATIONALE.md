# Rationale

## Changed hunk
`tree/src/t_stream.c`, `streamReplyWithRange()`: replaced the unconditional
`propagate_last_id = 1;` with the pre-fix `if (noack) propagate_last_id = 1;`.
This reverses the `t_stream.c` hunk of the fix. The code is the same as before
the fix (including the original comment). Without it, XREADGROUP without NOACK
propagates only XCLAIM, which does not carry entries-read, so `XGROUP SETID ...
ENTRIESREAD` is not sent and replicas end up with an inconsistent entries-read
and lag.

The `commands.def` and `xgroup-create.json` hunks are unrelated naming
cleanups and were not touched.

## Failing oracle cases
- `tests/unit/type/stream-cgroups.tcl`: "XREADGROUP ACK would propagate
  entries-read". The replica's entries-read does not match the expected 3.
- `tests/unit/multi.tcl`: "MULTI propagation of XREADGROUP". The replication
  stream is missing the `xgroup SETID * ENTRIESREAD *` entries.
