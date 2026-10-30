# Rationale

## Change: `tree/src/lua/script_lua.c`, `luaArgsToRedisArgv`

Reverses the single implementation hunk of fix.patch (the file moved from
`src/script_lua.c` to `src/lua/script_lua.c`). The `double2ll()` / `ll2string()`
branch for Lua numbers is removed, so every number argument is again formatted
with `fpconv_dtoa()`, which emits `%e`-style output when shorter (e.g. `2e+08`
for 200000000). Commands expecting integers (e.g. HINCRBY) then reject it with
"value is not an integer or out of range".

## Oracle failures

`EVAL - Lua number -> Redis integer conversion` fails:
`redis.pcall('hincrby','hash','field',200000000)` returns an error instead of
number 200000000. The test file aborts afterwards with an exception in that
test, so the later cases are reported as failing as well (incomplete run).
