# Re-introduced bug: workers crash when SharedArrayBuffer is unavailable (nodejs/node#39717)

**Bug.** `require('worker_threads')` (lib/internal/worker.js) unconditionally allocated the shared
cwd counter with the global `SharedArrayBuffer`. When SAB is not exposed (the test uses
`--enable-sharedarraybuffer-per-context`; the old `--no-harmony-sharedarraybuffer` flag no longer exists
in this V8), loading worker_threads throws `ReferenceError`, so workers (and the REPL) crash.

**Hunk (lib/internal/worker.js).** Corresponds to the fix's worker.js hunk
(`if (isMainThread && SharedArrayBuffer !== undefined && Atomics !== undefined)`). In today's code the
guard had been replaced by the native helper `constructSharedArrayBuffer(4)`, which works without the
global. I replaced it with `new SharedArrayBuffer(4)` (and dropped the now-unused import), restoring the
pre-fix dependency on the global. The worker_thread.js hunk was not changed: it uses `AtomicsLoad` from
primordials and no guard existed that could sensibly be removed without further breakage.

**Failing test.** parallel/test-worker-no-sab: "not ok", `ReferenceError: SharedArrayBuffer is not
defined at node:internal/worker:115:36`. Verified twice.
