# Rationale
Bug: writable.write()/end() callbacks received `undefined` instead of `null` as the error argument on success.

Hunks (all in lib/internal/streams/writable.js):
1. afterWrite: `cb(null)` -> `cb()` (fix hunk 1): write callbacks get undefined.
2. Writable.prototype.end: the already-finished branch `process.nextTick(cb, null)` -> `process.nextTick(cb, undefined)` (fix hunk 2; code was already split into separate branches in today's tree).
3. finish: `callFinishedCallbacks(state, null)` -> `callFinishedCallbacks(state)` (fix hunk 3; the loop now lives in callFinishedCallbacks(state, err), so err becomes undefined for the normal finish path).

Failing tests: parallel/test-stream-writable-end-cb-error and parallel/test-stream2-writable (strictEqual(err, null) assertions fail with undefined).
