# Rationale

All changes are in `processClientsWaitingReplicas()` in `src/replication.c`. They reverse the fix hunks in that function.

- Removed `last_aof_offset` and `last_aof_numreplicas`, and the separate WAITAOF branch of the cache check. This reverses the hunk that added those variables and the `!is_wait_aof` / `else if (is_wait_aof ...)` split. WAIT and WAITAOF share `last_offset` and `last_numreplicas` again, as before the fix.
- Removed the `if (is_wait_aof) {...} else {...}` that stored the cache. It is back to the unconditional `last_offset = ...; last_numreplicas = ...;`.
- Changed `continue` back to `return` in the "WAITAOF numlocal but appendonly disabled" error path. This reverses the fix's `return` -> `continue` hunk. The `return` leaves later blocked clients unprocessed.

The `server.h` hunk only changed a comment, so I did not touch it.

## Oracle failure

`WAIT and WAITAOF replica multiple clients unblock - reuse last result` fails with `Expected '1 2' to be equal to '1 1'`.

1. The WAIT client is satisfied first and caches its offset and replica count (2).
2. The WAITAOF client has a lower offset and wants only 1 replica, so it reuses that cached WAIT result.
3. It is unblocked with a replica count of 2, which is wrong. The real AOF-acked count is 1.

The other 37 oracle cases still pass.
