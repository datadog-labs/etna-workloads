# Re-introduced bug: pipe() ondata controls flow state after cleanup

**Bug:** In `Readable.prototype.pipe`, when `dest.write()` returns false the `pause()` helper called `src.pause()` even if the pipe had already been cleaned up (`unpipe()` called during the write). A source that was unpiped and `resume()`d inside the destination's transform is then paused again and never ends.

**Change (lib/internal/streams/readable.js, `pause()` inside `pipe`):** one hunk, matching the fix's single implementation hunk. `src.pause()` is moved out of the `if (!cleanedUp)` block so it runs unconditionally. The fix had put it inside the guard (the old code had it after the `ondrain` setup, outside the guard). The code has since moved from `ondata` into a `pause()` helper, so the hunk is expressed there.

**Failing test:** `parallel/test-stream-readable-unpipe-resume` gives `not ok` on two runs. The readStream never emits 'end', so `common.mustCall()` fails.
