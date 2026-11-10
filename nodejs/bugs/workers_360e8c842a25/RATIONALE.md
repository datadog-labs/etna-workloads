# Rationale

Bug: spawning a nested worker from a `-r` preload script crashed. In a worker, preload modules ran before the
worker finished its setup, so a `new Worker()` inside the preload hit uninitialised state.

Hunk (lib/internal/main/worker_thread.js): in the fix, `loadPreloadModules()` and the loader init were moved after
`workerIo.sharedCwdCounter = cwdCounter`. In today's code the loaders and preloads run in `initializeModuleLoaders(...)`,
so I moved `workerIo.sharedCwdCounter = cwdCounter;` to after that call. Preloads now run while
`sharedCwdCounter` is still undefined, as in the pre-fix ordering.

Failing test: parallel/test-preload-worker fails with
`TypeError: undefined is not an integer typed array. at process.cwd (node:internal/main/worker_thread:133)`
(raised while the preload runs in the nested worker).
