# Reproducer notes

`repro.sh` reproduces CVE-2021-32626, the bug fixed by commit `0f8b634cd5cd`
("Fix invalid memory write on lua stack overflow"). The fix added
`lua_checkstack()` guards before several places in the Lua<->server reply
conversion code push elements onto the Lua stack; `injection.patch` removes
two of those guards (in `ldbServer` and `luaReplyToServerReply`).

The script starts a single server and runs:

    EVAL "local a = {}; local b = {a}; a[1] = b; return a" 0

This is the same trigger as the upstream test "Script return recursive
object" in `tests/unit/scripting.tcl`. The returned table is a two-cycle
(`a` contains `b`, `b` contains `a`), so converting it to a server reply in
`luaReplyToServerReply()` recurses without any depth bound tied to the
table's actual size.

- On the **clean** (fixed) build, `lua_checkstack(lua, 4)` fails once the
  Lua stack can't grow further, so the server replies with a clean
  `-ERR reached lua stack limit` and the connection stays alive (a
  subsequent `PING` returns `PONG`).
- On the **buggy** build, the guard is missing, so the recursive push
  keeps writing past the allocated Lua stack, corrupting memory. The
  server crashes (segfault) handling the single `EVAL`: the CLI reports
  "Server closed the connection", the follow-up `PING` can't connect, and
  the script's liveness check (`kill -0` on the server PID) reports
  `SERVER CRASHED`.

Verified with `./check.sh`: clean build prints the ERR + PONG and exits 0;
buggy build prints the connection-closed error, a failed PING, and
`SERVER CRASHED`, with the server process gone.
