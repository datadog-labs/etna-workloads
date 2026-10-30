# Rationale

## Change: `tree/src/networking.c`, `processCommandAndResetClient`

Reverses the single implementation hunk of the fix. The fix saved
`old_client = server.current_client` before setting `server.current_client = c`
and restored it afterwards. 9.0.7 still had that code verbatim, so the revert
is direct:

- removed `client *old_client = server.current_client;`
- replaced `server.current_client = old_client;` (and its comment) with
  `server.current_client = NULL;`

When a script times out, `processEventsWhileBlocked` re-enters this function
for another client (or the same client's pipelined commands). The inner call
now sets `current_client` to NULL on exit, so when the outer call (the one
running the script) returns it sees `server.current_client == NULL` and
falsely reports the client as dead. The caller stops reading from that
client's buffer, so the pipelined `ping` after the timed-out `eval` is never
answered.

## Oracle cases expected to fail

`tests/unit/scripting.tcl`: "Timedout script does not cause a false dead
client" (the second reply, `PONG`, is never delivered after `SCRIPT KILL`).
