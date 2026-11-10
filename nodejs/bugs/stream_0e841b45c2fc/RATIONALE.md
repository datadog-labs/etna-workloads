# Re-introduced bug
Readable streams emit 'data' after 'error'/'close' when `read()` is called after destruction, and `unshift()` after destroy/error adds the chunk (which can then be emitted).

## Hunks (lib/internal/streams/readable.js)
1. `readableAddChunkUnshiftValue`: removed the `else if (kDestroyed | kErrored) return false;` branch (fix hunk 1, the `state.destroyed || state.errored` guard in the unshift path; code is now split into per-mode helpers).
2. `Readable.prototype.read`: `if (ret !== null && (state & (kErrorEmitted|kCloseEmitted)) === 0)` back to `if (ret !== null)` (fix hunk 3). The cosmetic blank-line hunk is omitted.

## Failing test
parallel/test-stream-readable-destroy: `not ok` (the `common.mustNotCall()` 'data' handler is called after error/close). Stable over two runs.
