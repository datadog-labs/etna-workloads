Starts a server with `--lua-enable-insecure-api yes` (plus `--enable-protected-configs yes`), then runs
`CONFIG SET lua-enable-insecure-api no` and evals `getfenv()`.
Clean: the eval fails with "nonexistent global variable 'getfenv'", because the Lua engine is reset.
Buggy: `lua_insecure_api_current` is never synced after startup, so the CONFIG SET is a no-op
for the engine and `getfenv()` still works (returns nil).
