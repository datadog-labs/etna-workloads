# Rationale

The fix's only implementation file, `src/script_lua.c`, now lives at `src/lua/script_lua.c`. Its
`luaReplyToRedisReply` still uses `lua_rawget` in the same places the fix introduced it.

Changed: every `lua_rawget` in `luaReplyToRedisReply` is back to `lua_gettable` (10 call sites).
They read the `err`, `ok`, `double`, `big_number`, `verbatim_string`, `format`, `string`, `map` and
`set` fields, and the array index loop. This reverses all 10 hunks of the fix, which replaced
`lua_gettable` with `lua_rawget`. The code is otherwise identical to the pre-fix code.

Effect: while converting a returned table to a reply, metatables are honoured again. An `__index`
that raises an error runs outside `pcall`, so Lua panics and the process exits.

Failing oracle cases: "EVAL - Return _G", "EVAL - Return table with a metatable that raise error"
and "EVAL - Return table with a metatable that call server". The server connection is closed and
the test run aborts. These are the cases the fix added.
