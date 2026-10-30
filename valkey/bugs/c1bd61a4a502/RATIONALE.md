# Rationale

In 9.0.7 the whole of #10969 is already reverted (matching fix.patch), so the fix's
server.c/server.h hunks cannot be reversed. I re-expressed the pre-fix state: the
replication placeholder in `call()`.

- server.h `serverOpArray`: adds `used` (reverses the fix's removal of `used`).
- server.c: re-adds `serverOpArraySet`, `serverOpArrayAppendPlaceholder`, `serverOpArrayTrim`;
  `serverOpArrayAppend`/`Free` use `used` and skip target-0 placeholders (reverses the
  hunk replacing them with the simple numops-based versions).
- server.c: `alsoPropagateRaw(..., index)` split out of `alsoPropagate` (reverses the hunk merging them).
- server.c `propagatePendingCommands`: iterates `used`, skips placeholders, frees on empty
  (reverses the matching hunk).
- server.c `call()`: saves a placeholder before `proc()` for CMD_WRITE|CMD_MAY_REPLICATE
  commands, fills it via `alsoPropagateRaw`, trims afterwards (reverses the call() hunks).

Not touched: the notify/propagateDeletion ordering in db.c/evict.c (9.0.7 is already in the
post-fix order) and the SPOP hunk (still correct under the placeholder; only needed for the
`del` ordering of a module-visible case).

## Effect
A lazy-expire `del` triggered during a command is appended after the command's placeholder,
so the replica sees `sadd s foo` then `del s` instead of `del` then `sadd`.

Oracle failure: `tests/integration/replication.tcl` "Test replication with lazy expire":
`Expected 'set' to be equal to 'none'` for the replica's `type s`.
