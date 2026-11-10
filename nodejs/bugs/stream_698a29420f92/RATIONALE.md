# Re-introduced bug: readable `awaitDrain` counter (nodejs 698a29420f92)

**Bug.** Readable state tracked drain-waiting pipe destinations with a plain counter
(`awaitDrain`) that is incremented on every `dest.write() === false` and decremented on each
`drain`. When a write recurses synchronously, the same destination can be counted several times,
and only one `drain` event arrives, so the counter never returns to 0 and the source can stay
paused forever. The fix replaced it with `awaitDrainWriters` (null | Writable | Set<Writable>).

All hunks are in `lib/internal/streams/readable.js` (the code moved there since the fix):
- ReadableState: `awaitDrainWriters = null` -> `awaitDrain = 0` (fix hunk 1).
- `addChunk` and `Readable.read`: reset `awaitDrain = 0` instead of clearing the Set/null (fix hunks 2, 3).
- `pipe()`: removed the single->Set promotion block (fix hunk 4); removed unused `SafeSet` import.
- `pipe()` `ondrain` condition checks `state.awaitDrain` (fix hunk 5).
- `pause()` in pipe: `awaitDrain++` guarded by pipes.includes(dest) && !cleanedUp (fix hunk 6).
- `pipeOnDrain(src)`: decrement counter, resume when it reaches 0 (fix hunk 7).

**Failing tests** (they assert on the new `awaitDrainWriters` property):
test-stream-pipe-await-drain, test-stream-pipe-await-drain-manual-resume,
test-stream-pipe-await-drain-push-while-write (assertion failures, e.g. `awaitDrainWriters` is
undefined instead of null/writable / `.size` of undefined). The recursion test and
test-stream2-basic still pass in this release.
