# Re-introduced bug: pipe drain resumes without clearing "paused" state

**Bug:** When a piped destination emitted 'drain', `pipeOnDrain` forced the source into flowing mode
directly and called `flow(src)` instead of calling `src.resume()`. The `kPaused` flag (set by an
earlier `pause()`) was never cleared, so `src.isPaused()` stayed true after the stream was flowing again.

**Hunk:** `lib/internal/streams/readable.js`, `pipeOnDrain`. This corresponds to the fix's single implementation hunk.
`src.resume()` is replaced with `state[kState] |= kHasFlowing | kFlowing; flow(src);`. The old code was
`state.flowing = true; flow(src)`, which in today's bitfield state is the same as setting those two flags.

**Failing test:** `parallel/test-stream-readable-pause-and-resume` reports `not ok` on both runs.
This is the `assert(!source3.isPaused())` check in the drain handler. I did not capture the exact
failure message text.
