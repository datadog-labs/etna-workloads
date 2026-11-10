# Re-introduced bug: no ERR_STREAM_PREMATURE_CLOSE in Readable async iterator

**Bug.** When a Readable is destroyed or closed before 'end' (e.g. `readable.destroy()` mid-iteration, or `fs.ReadStream.close()` inside `for await`), the async iterator finished silently (`done: true`) instead of rejecting with `ERR_STREAM_PREMATURE_CLOSE`, so truncated streams looked like complete ones.

**Hunk.** `lib/internal/streams/readable.js`, in `start()` of `createAsyncIterator`: the eos callback now treats an error with code `ERR_STREAM_PREMATURE_CLOSE` as a clean end (`error = null`). This corresponds to the fix's hunk changing `closeEmitted -> break` into `throw new ERR_STREAM_PREMATURE_CLOSE()`. The iterator was rewritten since the fix and now relies on `eos` to report premature close, so the old "break on close" behaviour is restored by swallowing that error. The fix's import hunk and TODO-comment removal need no counterpart.

**Failing test.** `parallel/test-stream-readable-async-iterators` fails (checked twice) with an `ERR_ASSERTION` whose `expected` is `{ code: 'ERR_STREAM_PREMATURE_CLOSE' }`.
