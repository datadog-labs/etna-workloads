# Re-introduced bug: Duplex does not forward writableObjectMode

**Bug:** `Duplex.prototype` did not expose `writableObjectMode` (inherited from Writable), so `duplex.writableObjectMode` was `undefined` instead of reflecting the stream's writable object mode.

**Change:** in `lib/internal/streams/duplex.js` (the code moved from `lib/_stream_duplex.js`), removed the `writableObjectMode` entry from the `ObjectDefineProperties(Duplex.prototype, {...})` call. This corresponds to the fix's single implementation hunk, which added that descriptor; removing it restores the old behaviour.

**Failing test:** `parallel/test-stream-duplex-props` — `AssertionError: Expected values to be strictly equal: + actual - expected + undefined - true` at line 13 (`d.writableObjectMode`).
