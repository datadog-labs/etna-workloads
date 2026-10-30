# Rationale

Fix (#5396): commandstats for commands run inside MULTI/EXEC were logged as EXEC.

## Change
`src/multi.c`, `execCommand()`: when executing each queued command, the loop set
`c->cmd = c->realcmd = c->mstate->commands[j].cmd`. It now sets only `c->cmd`,
leaving `c->realcmd` as EXEC. In 9.0.7 `call()` takes `real_cmd = c->realcmd`
and uses it for `calls`, `microseconds`, and failure stats. That is the modern
equivalent of the pre-fix code, which charged stats to the outer EXEC command
instead of the inner one. `fix.patch` has no other implementation hunks to reverse.

## Oracle
`tests/unit/introspection-2.tcl` "command stats for MULTI" fails:
`cmdstat exec` shows `calls=4` where `calls=1` is expected, because the inner
commands are counted as EXEC.
