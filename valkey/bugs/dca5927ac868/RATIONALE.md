# Rationale

Changed `tree/src/tracking.c`, `trackingInvalidateKey` (line ~410). This reverses the only implementation hunk of fix.patch.

The fix added `&& server.current_client->flag.executing_command` (formerly `flags & CLIENT_EXECUTING_COMMAND`) to the condition that queues the invalidation into `server.tracking_pending_keys`. I removed that clause, so a key invalidated for the current client is always queued, even if no command is executing. That is the pre-fix condition `target == server.current_client`.

Effect: when the tracking-table-max-keys eviction runs before a command is queued inside MULTI, the invalidation is queued and never drained, because `call()` is not reached. A later assert then crashes the server.

Oracle case that fails: "Regression test for #11715". The server crashes and the test client gets "I/O error reading reply".
