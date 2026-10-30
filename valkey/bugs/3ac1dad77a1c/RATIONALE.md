# Rationale

Bug: the #1118 fix (number -> string conversion with full precision for
redis.call args) tested `lua_isnumber()`, which is also true for *strings that
look like numbers*. Such strings were converted through a double and lost
precision. The fix (#1804) changed the test to `lua_type(...) == LUA_TNUMBER`.

## Change
`src/lua/script_lua.c`, argument conversion loop in the redis.call argv builder:
`if (lua_type(lua, j + 1) == LUA_TNUMBER)` -> `if (lua_isnumber(lua, j + 1))`.
This reverses the fix's one-line condition change; numeric strings again take
the double path (lua_tonumber + double2ll/fpconv_dtoa) instead of lua_tolstring.

## Oracle failure
"String containing number precision test (regression of issue #1118)":
SET key "12039611435714932082" then GET returns 12039611435714933000.
