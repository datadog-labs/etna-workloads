# Rationale

Fix hunk (src/functions.c, `functionLoadCommand`): added an `addReplyErrorFormat("Unknown option given: %s")` + `return` after the `replace` check in the option-parsing loop, so unknown options are rejected.

9.0.7 still has the same loop in `functionLoadCommand` (src/functions.c), with the error reply at the end of the loop body. I removed those two lines (the reply and the `return`), so an unrecognised option is silently consumed again, exactly the pre-fix behaviour.

## Oracle failure
`FUNCTION - Load with unknown argument` fails: `function load LUA test foo bar <code>` no longer returns `*Unknown option given*`; the options are skipped and the load proceeds (here it returns `ERR Library 'test' already exists`, since the library exists from an earlier test).
