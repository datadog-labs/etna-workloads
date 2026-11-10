# Re-introduced bug (nodejs 793a2792d577)

Bug: after an ESM job errored, re-running it did not rethrow the cached error. require() after a failed import() hit
`assert(status === kUninstantiated)` ("Unexpected module status 5"), and import() after a failed require() did not reject.

Hunks:
- lib/internal/modules/esm/loader.js (`getModuleJobForRequire`): removed the `else if (status === kErrored) throw job.module.getError()` branch
  (fix hunk 1) and the now-unused `kErrored` import. Without it, errored modules fall through to the status assertion.
- lib/internal/modules/esm/module_job.js (`ModuleJobSync.run`): removed the `status === kErrored` throw (fix hunk for run()), so
  errored status falls into `status > kInstantiated` and returns the module instead of rejecting.
- The debug-log drive-by hunks were not reverted (no behavioural effect).

Failing tests:
- test-import-module-retry-require-errored: got `Unexpected module status 5` instead of message 'test'.
- test-require-module-retry-import-errored-2: `Missing expected rejection.`
