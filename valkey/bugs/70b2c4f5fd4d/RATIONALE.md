# Rationale

Fix hunk reversed: `processClientsWaitingReplicas` in src/replication.c (the refactor
that made the "reuse last result" path produce the proper reply for WAITAOF).

In 9.0.7 the fix had since been extended with separate `last_aof_offset` /
`last_aof_numreplicas` state, so a plain reverse doesn't apply. I restored the pre-fix shape:
- A single shared `last_offset` / `last_numreplicas` for WAIT and WAITAOF (removed the AOF-specific variables).
- The cached-result fast path again does `addReplyLongLong(c, last_numreplicas); unblockClient(c, 1);`
  directly, so a WAITAOF client unblocked from it gets a WAIT-style integer reply instead of the
  `[numlocal, numreplicas]` array, and skips the numlocal check.
- The slow path records `last_offset`/`last_numreplicas` before the numlocal check, as in the original.

The error-message hunk is cosmetic and was not reverted.

## Oracle failures
- `WAITAOF replica multiple clients unblock - reuse last result`: the second client gets `1`, not `1 1`.
- `WAIT and WAITAOF replica multiple clients unblock - reuse last result`: a WAITAOF client gets `2` (WAIT-style integer), not `1 1`.
