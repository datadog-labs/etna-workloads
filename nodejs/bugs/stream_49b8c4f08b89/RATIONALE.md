# Re-introduced bug: non-strict isReadableNodeStream in eos (nodejs#40938)

**Bug:** `eos()`/`finished()` treated any object with `pipe` and `on` as a readable Node stream when checking premature close. For an http `ServerResponse` (a Writable with a `pipe`-like surface via legacy Stream), this made `finished(res)` report `ERR_STREAM_PREMATURE_CLOSE` instead of finishing cleanly with `undefined`.

**Hunks:**
1. `lib/internal/streams/end-of-stream.js` (fix hunk 1): in `isReadableFinished`-style check (`willEmitClose`/premature-close function, line ~96) the condition `readable && !readableFinished && isReadableNodeStream(stream, true)` is reduced to `readable && !readableFinished`, dropping the strict check.
2. `lib/internal/streams/utils.js` (fix hunk 2): `isReadableNodeStream(obj, strict = false)` loses the `strict` parameter and the `pause`/`resume` function checks.

**Failing test:** `parallel/test-stream-finished` reports `not ok` (stable over repeated runs), from the new http server/`finished(res)` case, where the callback receives a premature close error rather than `undefined`.
