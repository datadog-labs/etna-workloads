# Re-introduced bug (upstream f14d2e5a0c33)

**Bug:** the loader hook worker (`internal/modules/esm/worker`) must not spawn another loader hook worker. If its cascaded loader is created with custom-loader spawning enabled, each loader worker spawns another one with `--experimental-loader`, indefinitely.

**Change (one hunk, lib/internal/modules/esm/worker.js):** in `initializeAsyncLoaderHooksOnLoaderHookWorker()`, `shouldSpawnLoaderHookWorker` is set to `true` instead of `false`. This corresponds to the fix's whole mechanism (the `isLoaderWorker` flag threaded through `worker_thread.js`, `pre_execution.js`, `utils.js` and `createModuleLoader`). In today's code that mechanism is the `shouldSpawnLoaderHookWorker` option passed to `initializeModuleLoaders`. Flipping it removes the guard in `createModuleLoader`, so the worker spawns workers recursively, as before the fix.

**Failing test:** `es-module/test-loaders-workers-spawned` fails ("not ok") on both runs, with `ERR_INTERNAL_ASSERTION: asyncLoaderHooks should only be provided on the loader hook thread itself` on stderr (the worker tries to create a spawning loader; the assert in `createModuleLoader` trips before recursion can go on). The tests expect empty stderr and exit code 0.
