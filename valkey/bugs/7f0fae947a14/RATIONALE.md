# Rationale

## src/rdb.c (rdbLoadObject, stream consumer loading)
Reverses the sole implementation hunk of fix.patch: removes the
`if (!consumer) { rdbReportCorruptRDB("Duplicate stream consumer detected."); decrRefCount(o); return NULL; }`
check after `streamCreateConsumer(...)`. In 9.0.7 the code is the same apart from formatting. With the check gone, a duplicate consumer name makes `streamCreateConsumer` return NULL and `consumer->seen_time` dereferences NULL.

## Oracle
`corrupt payload: stream with duplicate consumers` fails: the server crashes (NULL deref) so the client gets "I/O error reading reply" instead of "Bad data format". The other 88 cases pass.
