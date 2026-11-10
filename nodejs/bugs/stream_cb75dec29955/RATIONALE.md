# Rationale

Bug: `eos()`/`finished()` decided a stream was already done using `!isWritable(stream)` / `!isReadable(stream)`. For legacy `Stream` objects (not Readable/Writable) isWritable/isReadable return `null`, so `!null` is true and finished() wrongly auto-closed them (callback fired) instead of never being called.

Change (lib/internal/streams/end-of-stream.js, 2 hunks, matching both fix hunks, re-expressed for the now `immediateResult = getEosErrored(stream)` code):
- `(writableFinished || isWritable(stream) === false)` -> `(writableFinished || !isWritable(stream))`
- `(readableFinished || isReadable(stream) === false)` -> `(readableFinished || !isReadable(stream))`

Failing test: parallel/test-stream-finished (the new "Legacy Streams" case: `finished(new Stream(), common.mustNotCall())` — callback is called). Fails stably (ran twice, "not ok").

Observed failure message (stable across runs): at test-stream-finished.js:432, `TypeError: Cannot read properties of undefined (reading 'code')` — an EventEmitter-based legacy stream gets its finished() callback called immediately with no error instead of waiting for a premature close. (The test's new Legacy Stream `mustNotCall` case would also fail, but the earlier assertion aborts the file first.)
