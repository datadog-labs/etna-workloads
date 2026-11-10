# Re-introduced bug: stream 'pause' not emitted on unpipe

**Bug.** `Readable.prototype.unpipe` stopped the flow by mutating the readable state directly instead of calling `pause()`. Pausing side effects, such as emitting `'pause'`, were therefore skipped. Fixed upstream by 0d0f151a.

**Changes** (`lib/internal/streams/readable.js`, `unpipe`). Today's code stores flowing in bit flags. The old `state.flowing = false` therefore becomes `kHasFlowing` set and `kFlowing` cleared.
1. The `!dest` (remove all) branch: `this.pause()` is replaced with `state[kState] |= kHasFlowing; state[kState] &= ~kFlowing;`. This matches fix hunk 1.
2. The single-dest branch, when `pipes.length === 0`: the same replacement. This matches fix hunk 2.

**Failing test.** `parallel/test-stream-pipe-unpipe-streams` fails with "Mismatched noop function calls. Expected exactly 1, actual 0." This is the `'pause'` handler that was never called. The test fails the same way on repeated runs.
