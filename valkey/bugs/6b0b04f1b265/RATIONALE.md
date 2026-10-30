# Rationale

Fix hunk: `lua_pop(lua, argc)` in `luaRedisGenericCommand` after building argv, so the
call arguments no longer occupy the Lua stack when the reply is parsed.

In 9.0.7 this logic lives in `luaArgsToServerArgv()` (src/lua/script_lua.c), called from
`luaRedisGenericCommand`. I removed the `lua_pop(lua, *argc);` ("Pop all arguments from the
stack...") there. Arguments stay on the stack, so replying with a huge-arity call
(`unpack` of 7999 values) makes the `lua_checkstack` in the reply parser fail -> assert/crash.

Oracle: "Script check unpack with massive arguments" crashes the server (assert in
redisProtocolToLuaType's stack check); the rest of scripting.tcl then aborts
(check.sh reports an incomplete run, 134 of 202 cases failing).
