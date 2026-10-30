# Rationale

## Changed hunk
`tree/src/lua/script_lua.c`, map-reply branch of `luaReplyToServerReply` (the 9.0.7 descendant of `luaReplyToRedisReply` in `src/scripting.c`).

This reverses the only implementation hunk of the fix. The fix changed the loop body from "emit value, dup key, emit key" to "dup key, emit key, emit value". I restored the pre-fix order:

    luaReplyToServerReply(...);   /* Return value. */
    lua_pushvalue(lua, -1);       /* Dup key before consuming. */
    luaReplyToServerReply(...);   /* Return key. */

Lua map replies are therefore emitted as value, key again. A RESP3 client gets a map of value => key, and a RESP2 client gets the pair flattened in the wrong order.

The fix's test-support hunks (`redis.tcl`, `tracking.tcl`) are test-only and were not touched.

## Oracle failures
`tests/unit/scripting.tcl` "Script with RESP3 map" fails. Four assertions fail with `Expected 'value field' to be equal to 'field value'`. This is the failure the fix's test guards against. Of the 202 scripting oracle cases and 59 tracking oracle cases, only this one fails.
