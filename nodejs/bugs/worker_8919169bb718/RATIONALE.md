# Re-introduced bug: workerData not exported to ESM workers (8919169bb718)

**Bug.** `lib/worker_threads.js` did not declare a `workerData` key in `module.exports`. The worker bootstrap assigns `workerData` onto the module later. ESM named exports for builtins are snapshotted from the keys present when the module is first loaded for a public loader. Without the placeholder, `import { workerData } from 'worker_threads'` in an ESM worker fails with "does not provide an export named 'workerData'".

**Hunks.**
1. `lib/worker_threads.js`: removed `workerData: null,`. This reverts the fix hunk that added it.
2. `lib/internal/main/worker_thread.js`: replaced `require('worker_threads')` with `BuiltinModule.map.get('worker_threads').compileForPublicLoader()`. The release now captures export keys lazily, so removing the key alone does not fail. This call captures the export keys (`exportKeys`) before `parentPort`/`workerData` are assigned, as the code did when the fix was written. It is needed to make hunk 1 observable. It has no counterpart in the upstream fix.

**Failing test.** `parallel/test-worker-mjs-workerdata` fails with:
`SyntaxError: The requested module 'worker_threads' does not provide an export named 'workerData'`.
It failed on two consecutive runs.
