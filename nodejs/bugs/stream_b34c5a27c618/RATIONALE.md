# Re-introduced bug: pipe() to a full sink deadlocks a paused source

**Bug:** When piping a paused Readable into a Writable with `writableNeedDrain === true`, `pipe()` only called `pause()` if the source was flowing. For a paused source `pause()` was skipped, so the `drain` listener was never registered. The source never resumed, and the pipe deadlocked.

**Hunk (lib/internal/streams/readable.js, end of `Readable.prototype.pipe`):** this corresponds to the fix's single implementation hunk. The fix changed `if (state.flowing) { pause(); }` to an unconditional `pause();`. I restored the guard, written for today's bitflag state as `if ((state[kState] & kFlowing) !== 0) { pause(); }`. `pause()` is what registers the dest `drain` handler, so skipping it for paused sources brings back the old behaviour.

**Failing test:** `parallel/test-stream-pipe-deadlock` reports `not ok`. The pipe never finishes, so the `finish` event never fires and `common.mustCall()` is not satisfied. I ran it twice and it failed both times. I did not capture the exact failure message.
