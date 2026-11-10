# Re-introduced bug: non-readable Duplex reports readableAborted === true after destroy()

**Bug.** `new Duplex({ readable: false, ... })` followed by `destroy()` made `readableAborted` return `true`, although the stream never had a readable side that could be aborted.

**Hunks.**
1. `lib/internal/streams/readable.js`, `readableAborted` getter. This matches the fix's only implementation hunk. I removed the `this._readableState.readable !== false &&` guard, which restores the pre-fix expression `!!(destroyed || errored) && !endEmitted`.
2. `lib/internal/streams/duplex.js`. This has no counterpart in the fix and is a re-expression for today's code. Since the fix, the Duplex constructor sets `endEmitted = true` when `readable === false`, and that masks the missing guard in hunk 1. I removed that line, so `endEmitted` stays false as it did before the fix. With only hunk 1 the test still passed.

**Failing test.** `parallel/test-stream-readable-aborted` fails on both runs. The assertion is `strictEqual(duplex.readableAborted, false)`, with actual `true` and expected `false`.
