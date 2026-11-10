# Re-introduced bug: stream.finished on closed OutgoingMessage

**Bug.** `finished()`/`eos` did not invoke its callback for an already-closed `http.OutgoingMessage` (e.g. a `ServerResponse` queried inside its `'close'` handler). OutgoingMessage is not a proper Writable (no `_writableState`), so eos didn't see that it was closed and waited for a `'close'` event that had already fired.

**Hunks (the fix's `eos` hunk, `closed = (!wState && !rState && stream._closed === true) || ...`, is now `isClosed()` in `lib/internal/streams/utils.js`; the `kClosed`→`_closed` renames are already `_closed` in the release).**
1. `lib/internal/streams/utils.js`: removed the `stream._closed === true && isOutgoingMessage(stream)` branch in `isClosed()`. This undoes the added `_closed` check for non-Writable streams.
2. `lib/_http_outgoing.js`: removed the later-added `OutgoingMessage.prototype.closed` getter. Without it `isClosed()` would still return `_closed` via `stream.closed`, which would hide the bug.

**Result.** `parallel/test-stream-finished` fails: the new http test's `finished(res, mustCall)` callback never runs, so the server never closes and the test times out (`not ok`, `timeout`). Run with `--timeout 20`, it fails the same way each time.
