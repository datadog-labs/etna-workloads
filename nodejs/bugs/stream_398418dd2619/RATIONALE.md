# Rationale

**Bug:** Iterating (`for await`) a Readable that has already ended (`endEmitted`) never completes; the async iterator does not notice the stream already ended, and the promise from `next()` hangs. Upstream fix initialised the iterator's `kEnded` to `stream._readableState.endEmitted`.

**Hunk (lib/internal/streams/readable.js, `start()` in `createAsyncIterator`):** The iterator was rewritten since the fix (no `kEnded` symbol; end is tracked via `error === null` set by the `eos` callback). Corresponding to the fix's `kEnded` initial value hunk, the new code ignores `endEmitted` at start: if the stream already emitted 'end', the end-detection state is reset to `undefined` ("active") and the eos listener is removed, so the iterator waits forever for 'readable'/end, as before the fix.

**Failing test:** parallel/test-stream-readable-async-iterators — "not ok" (the case "iterating on an ended stream completes" never resolves; test times out / the process exits with unsettled promise).
