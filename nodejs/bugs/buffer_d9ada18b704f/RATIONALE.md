# Blob.stream() source buffer leak

**Bug:** `Blob.prototype.stream()` registered a wakeup callback on the reader in the stream's `start()` and never released it. The strong `Reader::wakeup_` handle kept the reader, its DataQueue and the backing store reachable, so the source buffer leaked on every `stream()` call.

**Change (lib/internal/blob.js, `createBlobReaderStream`)**. All hunks revert the fix's hunks, adapted to today's code. Today's wakeup uses a setImmediate debounce, which I kept.
- `start()`: the wakeup is registered eagerly with `reader.setWakeup(...)` instead of being stored as `this.wakeup`. This reverses the fix's start() hunk. It makes the strong handle live for the stream's whole lifetime.
- `pull()`: removed the lazy `reader.setWakeup(this.wakeup)` registration.
- Removed the `clearWakeupIfIdle()` helper and its call in the backpressure path.
- Removed `reader.setWakeup(undefined)` from the readNext() EOS, error and empty-pendingPulls paths, and from `cancel()`.
- Comment reverted to say the wakeup is registered in start().

**Failing test:** `parallel/test-blob-stream-gc` fails on both runs with `AssertionError: unused Blob streams retained 67108864 bytes in arrayBuffers`.
