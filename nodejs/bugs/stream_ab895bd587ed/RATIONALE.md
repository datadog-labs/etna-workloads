# Re-introduced bug: pipe deadlock when starting with needDrain (nodejs #36544)

**Bug.** When `readable.pipe(dest)` is called while `dest.writableNeedDrain` is true, the old code only called `src.pause()` (and only if the source was flowing). It did not register the `drain` listener (`ondrain`) nor set `awaitDrainWriters`, so nothing ever resumed the source once `dest` drained: the pipe deadlocked.

**Change** (`lib/internal/streams/readable.js`, end of `Readable.prototype.pipe`). The fix's last hunk replaced `src.pause()` (guarded by `state.flowing`) with the shared `pause()` helper. The release already has the `pause()` helper (the other hunk, extracted from `ondata`, is unchanged), so only the call site is reverted: in the `dest.writableNeedDrain === true` branch, `pause()` becomes `if ((state[kState] & kFlowing) !== 0) src.pause();` (`state.flowing` is now a bit flag). This skips `awaitDrainWriters` and `dest.on('drain', ondrain)`, which brings back the deadlock.

**Failing test.** `parallel/test-stream-pipe-needDrain` fails (checked twice):
`Mismatched noop function calls. Expected exactly 2, actual 1.` (r 'pause') and
`Mismatched noop function calls. Expected exactly 1, actual 0.` (r 'end' never fires).
