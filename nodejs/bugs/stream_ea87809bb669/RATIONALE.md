# Re-introduced bug: _final called asynchronously (fix ea87809bb669)

**Bug:** `Writable` calls `_final` via `process.nextTick` after `end()` instead of synchronously. With `_final` defined, `'prefinish'` is therefore emitted asynchronously, while without `_final` it is emitted synchronously. Implementors also can't rely on `_final` running synchronously.

**Change (lib/internal/streams/writable.js only):**
- `prefinish()` corresponds to the fix's `prefinish` hunk. It no longer calls `_final` inline. It sets `kFinalCalled`, increments `pendingcb`, and schedules `process.nextTick(callFinal, ...)`. This is the pre-fix behaviour.
- A new `callFinal()` corresponds to the fix's `callFinal` hunk. It holds the `kSync` set/clear and the try/catch around `_final`, and is now run from the tick.
- The other fix hunks are not reverted. The `_stream_transform.js` hunk is a comment only. The http2 hunk and `finishMaybe` hunks are already different in this release. `onFinish` already matches the post-fix code.

**Failing test:** `parallel/test-stream-writable-finished` fails in both runs. The "Call _final synchronously" and "prefinish synchronously w/ final" cases fail with `actual: false, expected: true` from `assert.strictEqual(sync, true)`. The transform-final tests still pass.
