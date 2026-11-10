# Re-introduced bug (upstream e95e7f9af5)

Bug: 'readable' is not reliably emitted before the stream ends. When EOF is pushed, `onEofChunk` only emitted
'readable' via the old sync/async split, and skipped it if `emittedReadable` was already set, so a final
'readable' (needed to observe the end) could be lost or fire synchronously/not at all. Transform also no longer
started with `needReadable = true` in the old code path.

Hunks (lib/internal/streams/readable.js, `onEofChunk`): the fix replaced the sync/async branches with
`needReadable=false; emittedReadable=true; nextTick(emitReadable_)`. I restored the pre-fix branches: sync ->
`emitReadable()` (guarded by emittedReadable); async -> clear needReadable and call `emitReadable_` immediately only if
not already emittedReadable. (The release's extra kEofReadablePending skip logic in this branch was replaced by this;
the flag is now simply never set.)

Hunk (lib/internal/streams/transform.js): the fix deleted `this._readableState.needReadable = true;` after
`Duplex.call`; I re-added it.

Failing tests: parallel/test-stream-readable-emit-readable-short-stream, parallel/test-http-readable-data-event,
parallel/test-stream-readable-reading-readingMore (the expected extra final 'readable' event is not emitted:
mustCall count mismatch). Stable across two runs.
