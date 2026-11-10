# Rationale

**Bug:** `Readable.prototype.wrap` did not destroy the wrapping Readable when the wrapped (old-style) stream emitted `'close'` or `'destroy'`. It only re-emitted those events, so the Readable's `_destroy` was never called and its state was never updated.

**Change** (lib/internal/streams/readable.js, `Readable.prototype.wrap`; the file moved from lib/_stream_readable.js):
- `stream.on('close')` handler: `this.destroy()` -> `this.emit('close')`. This corresponds to the fix hunk that replaced `this.emit('close')` with `this.destroy()`.
- `stream.on('destroy')` handler: `this.destroy()` -> `this.emit('destroy')`. This corresponds to the fix hunk that replaced `this.emit('destroy')` with `this.destroy()`.

The other fix hunks (removing the proxied pause/resume re-emits, the decoder handling, and the `bind` cleanup) are not re-introduced. The rest of the cleanup already differs in this release, and those hunks are not needed for the destroy defect.

**Failing test:** `parallel/test-stream2-readable-wrap-destroy` fails with "Mismatched noop function calls. Expected exactly 1, actual 0." It fails identically in two runs. `parallel/test-stream2-readable-wrap` still passes.
