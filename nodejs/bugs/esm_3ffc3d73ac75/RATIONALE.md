# Re-introduced bug: missed `.async` -> `.hasAsyncGraph` rename in the require(esm) TLA check

## Bug
PR #59675 renamed `ModuleWrap#async` to `hasAsyncGraph`. One use in `ModuleJob.runSync` was
missed, so it read the now-nonexistent `.async` (always `undefined`). The check that should throw
`ERR_REQUIRE_ASYNC_MODULE` for a require()'d graph with top-level await never fired. Execution then
went on to `evaluateSync()` on an async graph. The test (an imported CJS that require()s a TLA ESM twice) crashes.

## Change
`lib/internal/modules/esm/module_job.js`, `ModuleJobBase.throwIfAsyncGraph()` (line 309):
`if (!this.module.hasAsyncGraph)` -> `if (!this.module.async)`.
This corresponds to the fix's single hunk (`this.module.async` -> `this.module.hasAsyncGraph`). Today's code
moved the check out of `ModuleJob.runSync` into the shared helper `throwIfAsyncGraph`, which both
`runSync` implementations call, so the stale name is re-expressed there.
`.async` is undefined, so the guard never throws.

## Failing test
`es-module/test-import-require-tla-twice` fails (stable over 2 runs). The child process aborts with
`Assertion failed: !obj->HasAsyncGraph()` at src/module_wrap.cc:945 (EvaluateSync), reached via
`runSync (module_job:673)`.
