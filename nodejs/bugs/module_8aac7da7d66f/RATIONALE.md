# Re-introduced bug: require(esm) with TLA fails badly on retry

**Bug.** Asynchronicity (TLA) of a required ESM graph was only detected on the first `require()` (right after instantiation). On a second `require()` of the same module, the cached job is already instantiated, the async check is skipped, and evaluation is attempted. The result is not `ERR_REQUIRE_ASYNC_MODULE` again: `ModuleWrap::EvaluateSync` hits an assertion and aborts.

**Hunks** (the release now uses `ModuleJob.throwIfAsyncGraph` and `module.hasAsyncGraph` instead of the fix's `module.async`, so I re-expressed the fix by removing the repeated check):
1. `lib/internal/modules/esm/loader.js`, `importSyncForRequire`: removed the `throwIfAsyncGraph` call on the cached-job path (status >= kInstantiated). This corresponds to the fix's loader.js hunk, which added the `job.module.async` check on that path.
2. `lib/internal/modules/esm/module_job.js`, `ModuleJobSync.runSync`: `throwIfAsyncGraph` runs only if the module was uninstantiated before `instantiate()`. This corresponds to the fix's module_job.js hunk, where the result of `instantiateSync()` was recorded and thrown on. Only the first attempt now detects TLA, which is the pre-fix behaviour.

**Failing test.** `es-module/test-require-module-tla-retry-require` fails: the second `require()` aborts in `node::loader::ModuleWrap::EvaluateSync` (Assert) instead of throwing `ERR_REQUIRE_ASYNC_MODULE`. It failed on both runs.
