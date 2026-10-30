# Rationale

## Change
`src/lua/script_lua.c`, `luaMaskCountHook`: removed the
`lua_sethook(lua, luaMaskCountHook, LUA_MASKLINE, 0);` call (and its comment)
that runs just before the kill error is raised.

This reverses the single implementation hunk of the fix (scripting.c,
`luaMaskCountHook`), which added that call. In 9.0.7 the code lives in
script_lua.c and also handles FUNCTION KILL, but the logic is the same: on
SCRIPT_KILL the hook is switched to fire on every line so that a script cannot
catch the kill error with pcall and re-enter pcall before being interrupted again.
Without it, only the count hook (every 100000 instructions) remains, so
`pcall(f)` swallows the error and the script is unkillable.

## Oracle
"Timedout read-only scripts can be killed by SCRIPT KILL even when use pcall"
fails: the script is never killed, the test times out and the run is
incomplete, so the later cases of tests/unit/scripting.tcl are reported failing too.
