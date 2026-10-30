repro.sh runs a Lua script (pure busy loop, then 5 `ping` calls) that exceeds busy-reply-threshold, so the
server re-enters the event loop; a second client's `ping` (answered BUSY) is processed meanwhile through a
nested processCommandAndResetClient. With the bug, that nested call resets server.current_client to NULL
instead of restoring the outer client, so the script's remaining commands (and the EVAL itself) are not
counted for the calling client. The script prints that client's `tot-cmds`: 6 on the clean build, 0 on the buggy one.
(The upstream "false dead client" symptom, a stalled pipelined ping, did not reproduce directly with these builds.)
