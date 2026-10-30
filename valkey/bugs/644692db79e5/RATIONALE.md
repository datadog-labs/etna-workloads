# Rationale

Fix hunk (src/eval.c): the Lua debugger's command dispatch was extended to accept
`server` (SERVER_API_NAME) in addition to `r`/`redis`, so `server ping` runs a command.

In 9.0.7 that dispatch lives in `src/lua/debug_lua.c` (the `ldbServer` branch of the
debugger command loop). I removed the `!strcasecmp(argv[0], SERVER_API_NAME)` alternative,
restoring the pre-fix behaviour where `server <cmd>` is not recognised. (`r`, `redis`, `v`,
`valkey` still work; `v`/`valkey` were added later and are unrelated to this fix.)

## Oracle failure
`Test scripting debug lua server invocations` fails: the debugger replies
`<error> Unknown Lua debugger command or wrong number of arguments.` instead of PONG.
