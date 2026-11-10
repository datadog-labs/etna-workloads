# Re-introduced bug: fused stateless transforms flushed as a single chained value

**Bug.** When consecutive stateless transforms are fused, the end-of-stream flush
sent `null` to the first transform only. Its output was passed as the input to the
next transform, and `null` was never sent to later transforms. Later transforms
therefore never got their own final flush. Their flush output (for example
`'-B'`) was lost, and data emitted by an upstream flush was not processed as normal
input by downstream transforms.

**Changes, all in `lib/internal/streams/iter/pull.js`.**
- `applyFusedStatelessSyncTransforms` flush section: this matches the sync
  implementation hunk of the fix. I put back the old single `current` chain,
  `current = run[i](current)`, followed by one `processTransformResultSync`. It
  replaces the per-transform `pending`/`next` loop that fed `null` to every transform.
- `applyFusedStatelessAsyncTransforms` flush section: this matches the async hunk of
  the fix. I restored the old chain with `isPromise`/`await` and the
  inline Uint8Array/string normalisation.
- The `appendTransformResult*` helpers from the fix hunks are left in place,
  because other code in the release now uses them.

**Failing tests.** Both oracle tests fail on every run: `parallel/test-stream-iter-pull-sync`
and `parallel/test-stream-iter-pull-async`. I did not read the assertion text. The
output was filtered to the TAP `ok`/`not ok` lines. The failing case should be the
consecutive-flush test, which expects `'x-A-B'`.
