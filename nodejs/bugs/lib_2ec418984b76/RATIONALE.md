# Rationale

**Bug:** `Writable.toWeb()` (`newWritableStreamFromStreamWritable`) validated its argument by requiring `_writableState` to be an object. `http.OutgoingMessage`/`ServerResponse` is not a `stream.Writable` and has no `_writableState`, so `Writable.toWeb(res)` threw `ERR_INVALID_ARG_TYPE`.

**Hunk (lib/internal/webstreams/adapters.js):** corresponds to the single implementation hunk of the fix. I removed the duck-typed `write`/`on` check (`checkIfWritableOrOutgoingMessage`) and restored the original `typeof streamWritable?._writableState !== 'object'` condition. The surrounding code changed since the fix (added `options` param, trailing commas), so the hunk was re-expressed for current code.

**Failing test:** `parallel/test-stream-toWeb-allows-server-response` fails (`not ok`) on two consecutive runs, because `Writable.toWeb(res)` throws `ERR_INVALID_ARG_TYPE`.
