# Re-introduced bug: setEncoding() ignores already-buffered chunks

**Bug:** `Readable.prototype.setEncoding()` only installed the new decoder; chunks already in the read buffer stayed as Buffers, so later `data` events emitted Buffers (or mixed Buffers/strings) instead of decoded strings.

**Change (lib/internal/streams/readable.js, `setEncoding`):** removed the block that decodes the existing buffer (loop over `state.buffer.slice(state.bufferIndex)` with `decoder.write`, `decoder.end()` if ended, clearing the buffer, pushing the decoded string, and resetting `state.length`). This corresponds to the fix's added hunk in lib/_stream_readable.js (the "Iterate over current buffer" block), re-expressed for today's code (bufferIndex array instead of linked list). Without it the old behaviour returns. The `fastChunk` materialization and decoder setup are untouched.

**Failing test:** parallel/test-stream-readable-setEncoding-existing-buffers:
`AssertionError: Expected values to be strictly deep-equal: actual [Buffer [97], 'b'] expected ['ab']`.
