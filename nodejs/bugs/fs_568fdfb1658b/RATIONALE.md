# Re-introduced bug: fs.WriteStream autoClose order (fix 568fdfb1658b)

**Bug.** WriteStream's autoClose was done by manually calling `this.destroy()` inside `_final`
(before the final callback) instead of relying on `autoDestroy`. The stream was therefore
destroyed (and fd closed) before 'finish' was emitted, so `file.destroyed` was true inside the
'finish' handler and 'close' ordering invariants were broken.

**Change (lib/internal/fs/streams.js, one hunk).** Added `WriteStream.prototype._final` that calls
`this.destroy()` when `this.autoClose` is set, then `callback()`. This corresponds to the fix's
removal of the `if (this.autoClose) this.destroy();` block from `_final` (the release no longer has
a `_final` at all, since autoDestroy is already used; the fix's other hunks - the autoDestroy default
and `this.autoClose` assignment - are already in the "fixed" form in this release via the
autoClose getter/setter over autoDestroy, so only the `_final` hunk is restored). The error-path
`destroy()` in `_write` was not restored: the current `_write` code is structured differently.

**Failing tests** (stable over 2 runs):
- parallel/test-fs-read-stream-autoClose: "Mismatched <anonymous> function calls. Expected exactly 1, actual 0."
  (the 'finish' handler asserting `destroyed === false` does not complete successfully).
- parallel/test-fs-write-stream-autoclose-option: same message.
