# Rationale

Fix hunk reversed: `processCommand` switching from `lookupCommandBySds(argv[0])` to the new `isContainerCommandBySds(argv[0])`.
In 9.0.7 that check lives in `commandCheckExistence` (src/server.c). I changed
`isContainerCommandBySds(c->argv[0]->ptr)` back to `lookupCommandBySds(c->argv[0]->ptr)`,
which splits argv[0] on `|` and so treats `config|get` as a valid (container) command.
The `c->argc >= 2` guard added later stays, so the NULL argv[1] crash is not
reproduced, but the wrong classification is: a name like `CONFIG|GET` with a bad
argument yields "unknown subcommand ... Try CONFIG|GET HELP." instead of "unknown command".
The other fix hunks (error format `%.128s`, the new function itself) are already present and untouched.

Failing oracle case: "Subcommand syntax error crash (issue #10070)":
`r CONFIG|GET GET_XX` returns `unknown subcommand 'GET_XX'. Try CONFIG|GET HELP.` rather than matching `*unknown command*`.
