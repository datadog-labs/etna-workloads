# Reproducer notes

`repro.sh` starts a single valkey-server, then runs the upstream regression
test "Script check unpack with massive arguments" (added by fix.patch):

```lua
local a = {}
for i=1,7999 do a[i] = 1 end
return redis.call("lpush", "l", unpack(a))
```

This pushes 7999 Lua stack slots as command arguments to `redis.call`. The
fix (`lua_pop(lua, argc)` in `luaRedisGenericCommand`, src/scripting.c) pops
the call arguments off the Lua stack before `redisProtocolToLuaType` /
`luaReplyToRedisReply` converts the command's reply back into Lua, leaving
enough stack headroom. Without it (the injected bug), the leftover 7999
argument slots plus the reply conversion overflow the Lua stack, hitting the
`lua_checkstack` assertion in `redisProtocolToLuaType`
(tests/.../script_lua.c:260 "lua stack limit reach when parsing server.call
reply") and the server crashes with a Guru Meditation report.

Differences observed between the two builds:

- **clean (9.0.7)**: `EVAL` returns `7999`, the server stays up, and a
  follow-up `PING` returns `PONG`.
- **buggy (injection.patch applied)**: the server crashes while handling
  `EVAL` (`CLI` reports "Error: Server closed the connection"), the
  follow-up `PING` fails to connect, and the crash log contains
  "Guru Meditation" (detected deterministically via `grep` and printed as
  the fixed line `CRASHED`).

The script avoids any non-deterministic output: no raw log/timestamp/pid is
printed, and the background server is `disown`ed so bash's asynchronous
"Aborted (core dumped)" job-control notice (which includes the PID) never
reaches stdout/stderr.
