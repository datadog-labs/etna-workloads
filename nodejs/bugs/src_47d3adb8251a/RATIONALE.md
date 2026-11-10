# Re-introduced bug: `--v8-pool-size=0` creates no worker threads

With `--v8-pool-size=0`, `NodePlatform` created a `WorkerThreadsTaskRunner` with 0 threads. V8 background tasks (e.g. scheduled by `gc()`) then had no thread to run on, so the process never terminated while those tasks were pending (it hangs).

## Hunks (src/node_platform.cc)
1. Removed the `GetActualThreadPoolSize()` helper (fix hunk 1, which added it). It is removed because it would otherwise be an unused static function.
2. Removed the `thread_pool_size = GetActualThreadPoolSize(thread_pool_size);` call in the `NodePlatform` constructor (fix hunk 2). The raw value 0 is passed to `WorkerThreadsTaskRunner` again, as before the fix.

## Failing test
`parallel/test-v8-flag-pool-size-0`: `not ok`, timeout (exitcode -15, "timeout") because `gc()` leaves a pending V8 task that no thread handles. The failure was stable across two runs.
