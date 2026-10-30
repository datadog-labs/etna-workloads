repro.sh starts a server and runs `EVAL "error({})" 0`, then PING.

Clean: returns "ERR unknown error script: ..." and the server stays up (PONG).
Buggy: the Lua error-info msg is left NULL, so the server segfaults; the CLI loses its connection and the later PING can't connect.
