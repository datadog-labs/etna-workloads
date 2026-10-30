# Rationale

## Changed hunk
`src/blocked.c`, `blockForKeys()`: removed the `if (!c->flag.reexecuting_command)` guard
(9.0.7 name for `CLIENT_REPROCESSING_COMMAND`) so `c->bstate->timeout = timeout;` is
unconditional again. This reverses the first hunk of fix.patch in blocked.c. The flag
setting in `call()` already exists in 9.0.7 and is left alone; it is simply no longer
consulted, which is the pre-fix behaviour. The module.c hunk is a refactor that only
supported the fix, and the server.c comment typo hunk is not behavioural, so they are untouched.

## Oracle failures
- stream-cgroups: "Blocking XREADGROUP for stream key that has clients blocked on stream - reprocessing command" (elapsed 1286ms, expected 1000-1199).
- zset: "BZPOPMIN unblock but the key is expired and then block again - reprocessing command" (elapsed 1206ms, expected 1000-1150).

The timeout restarts when the command is re-processed and blocks again, so the total block time exceeds the original timeout.
