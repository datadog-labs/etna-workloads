## What the reproducer does

Starts a single valkey-server on `$PORT`, then issues an `EVAL` whose script
returns a table with a metatable whose `__index` handler raises a Lua error:

    local a = {}
    setmetatable(a, {__index=function() error('boom') end})
    return a

This exercises `luaReplyToRedisReply()` in `src/lua/script_lua.c`, which walks
the returned table looking for special keys like `err`, `ok`, `double`, etc.

## What differs between the builds

- **Clean build (fixed, uses `lua_rawget`)**: the table lookups bypass the
  metatable entirely, so no error is raised. The script's return value is
  serialized normally and the server stays up; the following `PING` returns
  `PONG`.

- **Buggy build (`injection.patch`, uses `lua_gettable`)**: the table lookup
  triggers the `__index` metamethod, which calls `error('boom')`. This error
  happens outside of a protected Lua call, so the Lua interpreter panics:
  `PANIC: unprotected error in call to Lua API (user_script:1: boom)`, and the
  whole valkey-server process exits. The client sees "Server closed the
  connection", and the subsequent `PING` fails with "Connection refused".

This matches the upstream fix (commit 020e046b4210, "Fix #11030, use
lua_rawget to avoid triggering metatables and crash"), confirmed by
`./check.sh` showing the clean build replying `PONG` while the buggy build
crashes and refuses further connections.
