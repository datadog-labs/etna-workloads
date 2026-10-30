# Rationale

Single hunk, `tree/src/networking.c`, `setProtocolError()`. It reverses the only implementation hunk of fix.patch.

- Removed the `if (server.hide_user_data_from_log) { "*redacted*" } else {...}` wrapper. The query buffer sample (`c->querybuf + c->qb_pos`, which can hold user data) is now always dumped, even with `hide-user-data-from-log yes`.
- Restored the pre-fix sample text, `Query buffer during protocol error: '...'`, and the old log format `"... from client: %s. %s"`.
- The surrounding 9.0.7 code (`isReplicatedClient`, `catClientInfoString(..., server.hide_user_data_from_log)`) is unchanged, so the code is otherwise equivalent to the pre-fix function.

## Oracle failures (tests/integration/logging.tcl)

- "Config hide-user-data-from-log is on": the log has no `Query buffer: *redacted*`. It leaks the raw `$blabla` buffer instead, which is the bug.
- "Config hide-user-data-from-log is off": the log says `Query buffer during protocol error:` rather than `Query buffer: `, so the pattern `*Query buffer: *$blabla*` does not match.
