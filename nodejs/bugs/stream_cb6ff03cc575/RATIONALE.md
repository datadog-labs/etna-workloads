# Re-introduced bug: ArrayBuffer rejected by CompressionStream/DecompressionStream

**Bug.** `newWritableStreamFromStreamWritable` (used by CompressionStream/DecompressionStream) passed
chunks straight to `streamWritable.write()`. A plain `ArrayBuffer` is not a valid chunk for a
non-object-mode Node stream, so `writer.write(arrayBuffer)` failed instead of being accepted as a BufferSource.

**Change (lib/internal/webstreams/adapters.js).** In the `write(chunk)` of `newWritableStreamFromStreamWritable`,
removed the `if (!streamWritable.writableObjectMode && isAnyArrayBuffer(chunk)) chunk = new Uint8Array(chunk)`
block. This corresponds to the fix's single implementation hunk (which added the equivalent
`isArrayBuffer` conversion; today's code uses `isAnyArrayBuffer`, inside a try block). I also removed the
now-unused `isAnyArrayBuffer` import (the counterpart of the fix's added import).

**Failing tests** (stable across two runs): `parallel/test-webstreams-compression-buffer-source` and
`parallel/test-whatwg-webstreams-adapters-to-writablestream` both report `not ok`
(ArrayBuffer chunks are no longer converted / are rejected by the underlying stream).
