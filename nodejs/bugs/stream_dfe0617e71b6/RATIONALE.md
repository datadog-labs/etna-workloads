# Utf8Stream: early 'drain' after reopen()

**Bug.** After `reopen()`, the file-open callback in `#openFile` schedules `process.nextTick(() => emit('drain'))`. If a 'ready' listener starts a write, that write is still in flight on the nextTick, so 'drain' fires early. A listener that reads the file on 'drain' then sees it empty or incomplete. The real 'drain' still comes later from `#release()`, so a second 'drain' is also emitted.

**Change** (`lib/internal/streams/fast-utf8-stream.js`, in `fileOpened`):
- Fix hunk: `} else if (reopening && !this.#writing) {` replaced `} else if (reopening) {`, and the explanatory comment was added. Reverted by restoring `else if (reopening)` and removing the comment.
- Today's code emits through `#emitDrain()`, which has its own `if (this.#writing) return;` guard that silently masks the bug when the condition alone is reverted. I therefore also restored the original `process.nextTick(() => this.emit('drain'))`. That is the old unguarded behaviour.

**Failing tests.**
- `parallel/test-fastutf8stream-reopen` fails ("not ok") on the stock in-tree test in the runs I made after the final change.
- The regression test from the fix is not in the tree, so I ran it standalone from the scratch directory. It fails 3/3 with `AssertionError ERR_ASSERTION: Expected values to be strictly equal` on the data read on 'drain', because the file is read before the write completes.
- With only the condition reverted, the new test passed, because of the `#emitDrain` guard.
