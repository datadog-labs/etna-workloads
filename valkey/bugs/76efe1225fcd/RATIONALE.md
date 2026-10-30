# Rationale

Changed `tree/src/lua/script_lua.c`, argument loop in `luaArgsToServerArgv`
(was `luaRedisGenericCommand`): `lua_type(lua, j + 1) == LUA_TNUMBER` became
`lua_isnumber(lua, j + 1)`.

Reverses the fix hunk that changed `lua_isnumber(lua,j+1)` to
`!luaReallyIsString(lua,j+1) && lua_isnumber(lua,j+1)`. In 9.0.7 the same
"only real Lua numbers" check is expressed as `lua_type(...) == LUA_TNUMBER`
(equivalent to `luaReallyIsString` being false and the value being a number,
since lua_isnumber also accepts numeric strings). Going back to `lua_isnumber`
makes numeric strings take the number->string path, losing precision.

Oracle failure: "String containing number precision test (regression of issue
#1118)": expected `12039611435714932082`, got `12039611435714933000`.
