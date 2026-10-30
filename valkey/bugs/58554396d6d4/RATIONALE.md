# Rationale

## Change
`tree/src/t_string.c`, `incrbyfloatCommand`: removed
`rewriteClientCommandArgument(c, 3, shared.keepttl);`.

Reverses the fix hunk that appended `KEEPTTL` (argv[3]) to the propagated
`SET`. In 9.0.7 the `SET` and `KEEPTTL` objects are shared objects
(`shared.set`, `shared.keepttl`) instead of per-call `createStringObject`
(the aux1/aux2 renaming in the fix is cosmetic), so the equivalent of the
pre-fix code is simply not rewriting argument 3. INCRBYFLOAT is then
propagated as `SET key value`, which clears the TTL on replicas/AOF.

## Oracle
`tests/integration/replication.tcl`: "INCRBYFLOAT replication, should not remove
expire" fails: master and replica `DEBUG DIGEST` differ, since the replica lost
the expire. The other 69 cases pass.
