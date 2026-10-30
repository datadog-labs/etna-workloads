# Rationale

The 9.0.7 tree already contains the fix (functionReset / functionsLibCtxReleaseCurrent
with per-engine VM reset). The pre-fix behaviour was that FUNCTION FLUSH only cleared
the library ctx and never re-created the Lua VM.

Changed (src/functions.c, `functionsLibCtxReleaseCurrent`):
- Removed `scriptingEngineManagerForEachEngine(resetEngineOrCollectResetCallbacks, ...)` in both
  the sync and async branches (and the now-unused helper). This reverses the fix hunk that
  introduced `resetEngineOrCollectResetCallbacks` and the engine_callbacks list in the
  flush path. Async passes NULL callbacks to `freeFunctionsAsync`, as before the fix.
  Functions are again released via per-function `lua_unref` (no GC, so memory isn't
  reclaimed), and with ASYNC the bio thread unrefs in the shared function Lua state
  concurrently with FUNCTION LOAD on the main thread.

Oracle failures: "FUNCTION - test function flush" style memory checks (used_memory_vm_functions
unchanged after flush) and "FUNCTION - test loading function during the flush async"
(crash/error while loading during async flush).
