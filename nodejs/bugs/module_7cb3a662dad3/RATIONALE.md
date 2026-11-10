# Re-introduced bug (fix 7cb3a662)

**Bug:** An ESM that failed `require()` because of top-level await stays at status kInstantiated. Importing it again via `ModuleJobSync.run()` should evaluate it asynchronously. With the bug, that path is not handled and import() fails with an internal assertion error.

**Change:** `lib/internal/modules/esm/module_job.js`, `ModuleJobSync.run()`. The branch `status === kInstantiated || status === kUninstantiated` now reads `status === kUninstantiated`. This corresponds to the fix hunk that added the `status === kInstantiated` branch, which re-evaluates the module asynchronously. Before the fix, kInstantiated fell through to the assertion. Today's code has the extra kUninstantiated handling and the kErrored handling, and I left both as they were.

**Failing tests:** test-require-module-tla-retry-import, test-require-module-retry-import-evaluating and test-require-module-retry-import-errored fail. The first two report `ERR_INTERNAL_ASSERTION: Unexpected status of a module that is imported again after being required. Status = 2`. I did not read the failure message for -errored. test-require-module-tla-retry-import-2 still passes. The failures were identical across two runs.
