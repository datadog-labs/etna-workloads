# Rationale

The fix made blocked clients that end in an error count in command stats. The XREADGROUP/list/zset/module-key hunks in blocked.c no longer exist in 9.0.7, because blocked commands are now reprocessed through `call()`. Two hunks still have a counterpart.

1. `src/blocked.c`, `unblockClientOnError()`. This reverses the networking.c hunk, which added `updateStatsOnUnblock(target, 0, 0, 1)` after CLIENT UNBLOCK ... ERROR. Before the fix, the error-unblocked command was never flagged as failed in commandstats. Today the call passes `ERROR_COMMAND_REJECTED`. I changed it to `0`, so the command's calls and usec are updated but no failure is recorded.
2. `src/server.c`, `call()`. This reverses the hunk that added `else if (c->deferred_reply_errors) real_cmd->failed_calls++`. It is the same defect: errors handled inside RM_Call are not counted as failed calls. I removed the `deferred_reply_errors` branch and kept the plain `incrCommandStatsOnError(real_cmd, ERROR_COMMAND_FAILED)` call.

## Oracle
`tests/unit/info.tcl` "errorstats: blocking commands" fails. After `client unblock <id> error`, `cmdstat blpop` shows `rejected_calls=0,failed_calls=0`. The test expects the unblock error to be counted (`rejected_calls=1` in 9.0.7, `failed_calls=1` in the original fix's test).

The module test for hunk 2 (`blockedclient.tcl`, "module client error stats") is not in the oracle, so I did not run it.
