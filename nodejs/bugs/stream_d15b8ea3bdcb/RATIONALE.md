# Re-introduced bug: async iterator completes early when _destroy errors late

**Bug.** If a Readable is destroyed and its `_destroy` calls the callback with an error later than one tick,
`next()` on the async iterator resolved `{done: true}` instead of rejecting with that error.

**Change (lib/internal/streams/readable.js, `createAsyncIterator().next()`).** The fix replaced the
"defer one nextTick, then reject-if-error-else-done" logic in `next()` for destroyed streams with a wait on
`finished()`. The async iterator was since rewritten (the file lib/internal/streams/async_iterator.js is gone), and
`next()` now waits on `eos` for a destroyed stream. The single hunk I added corresponds to the fix's `if (this[kStream].destroyed)`
hunk, reversed: when the stream is destroyed and no error/end is known yet, it defers one `process.nextTick`
and then rejects with `error` if set, else resolves `{done: true}`. An error delivered after more than one tick
is therefore lost, which is the pre-fix behaviour.

**Verification.** A standalone repro of the fix's new test prints `resolved { done: true }` (clean release rejects with the error).
`parallel/test-stream-readable-async-iterators` fails ("not ok 1", stable over repeated runs). The failure I observed
is at test line 723 (fs.ReadStream `close()` during `for await`: `AssertionError`, actual `ERR_ASSERTION`,
expected `ERR_STREAM_PREMATURE_CLOSE`, from "should have thrown"). It is the same early-completion
defect hitting a different case. The test added by the fix (`setTimeout(() => callback(_err), 1)`) is also affected, per the repro.
The fs case could not be separated from the target case, since both are a destroyed stream whose error arrives later.
