# Rationale

Fix 4b8f3ed9 (AOF loading did no command existence/arity checks) is reverted in 9.0.7.

## src/aof.c, loadSingleAppendOnlyFile
Reverses the aof.c hunks: the `commandCheckExistence` / `commandCheckArity` check is
replaced by the old bare `lookupCommand` + "Unknown command ... reading the append only
file" error (keeping 9.0.7's `hide_user_data_from_log` redaction), and
`fakeClient->cmd = fakeClient->lastcmd = cmd` moves back to just before execution.
Without the arity check, `cluster` (container command, argc 1) and `cluster slots xxx`
reach `cmd->proc` unchecked.

## src/server.c, commandCheckExistence
Reverses the `&& c->argc >= 2` condition. The function is no longer called from the AOF
path, so this is only for fidelity with the fix; the processCommand path is unaffected.
(The whitespace-only hunk in processCommand is not reproduced.)

## Oracle failures (tests/integration/aof.tcl)
- "Unknown command: Server should have logged an error": the log message is back to
  "Unknown command 'bla'...", not matching the new `*unknown command 'bla'*` pattern.
- "Test command check in aof won't crash": the expected "wrong number of arguments for
  'cluster' command" message is not logged; the server no longer fails with it.
