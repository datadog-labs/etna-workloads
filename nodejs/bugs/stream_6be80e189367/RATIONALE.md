# Re-introduced bug: legacy pipe error handling (nodejs/node#35237)

**Bug:** `Stream.prototype.pipe` (legacy) registered its `onerror` handler with `on()`, so it ran after user-land error listeners. When it found no other listeners it `throw`ed the error instead of emitting `'error'`. A `Stream.pipe(PassThrough)` whose destination was destroyed with an error, and which had a `once('error')` handler, saw the handler removed by `cleanup()`. The error was then thrown as an uncaught exception instead of being handled.

**Changes (all in lib/internal/streams/legacy.js):**
1. In `onerror`, `this.emit('error', er)` became `throw er;`. This matches the fix hunk that changed `throw er` to `this.emit('error', er)`. The current code already used `this.listenerCount?.(...)`, so only the body was reverted.
2. `prependListener(source|dest, 'error', onerror)` became `source.on(...)` / `dest.on(...)`. This matches the fix hunk that swapped `on` for `prependListener`. The `prependListener` helper and the `{ Stream, prependListener }` export hunks were left in place, since `readable.js` still uses them and removing them would add unrelated churn.

**Failing test:** `parallel/test-stream-pipe-error-handling` reports `not ok`, with `Error: this should be handled` thrown as uncaught. I ran it twice and it failed both times.
