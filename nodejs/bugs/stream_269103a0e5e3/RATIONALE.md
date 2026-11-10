# Re-introduced bug (nodejs/node 269103a0e5e3)

**Bug:** On EOF of a Readable, `onEofChunk` always scheduled `'readable'` via `process.nextTick` (with `needReadable=false`, `emittedReadable=true`). The fix emits it synchronously when the stream is not in sync mode, because ecosystem modules such as dicer rely on that. With the bug, 'readable' fires an extra time or one tick late at EOF.

**Hunk:** `lib/internal/streams/readable.js`, `onEofChunk`. This corresponds to the fix's single implementation hunk in `lib/_stream_readable.js`. The file has moved since then. The release's sync/non-sync branches, which included a `kEofReadablePending` variant, are replaced by the pre-fix code: clear `kNeedReadable`, set `kEmittedReadable`, and `process.nextTick(emitReadable_, stream)`. The `kEofReadablePending` constant and its other uses are left in place and are now dead code.

**Failing tests (both runs, stable):** all six oracle cases report "not ok". They are test-stream-readable-emittedReadable, test-stream-readable-emit-readable-short-stream, test-stream-readable-needReadable, test-stream-readable-reading-readingMore, test-stream2-transform and test-stream2-httpclient-response-end. I did not record the individual assertion messages. They are the expected-call-count and timing assertions that the fix's test hunks changed.
