# Bug
`finished()`/eos treated a Readable that emitted 'close' before 'end' as cleanly finished whenever `readable._readableState.ended` was true (EOF pushed), even if 'end' never fired and buffered data remained (e.g. push('asd'); push(null); destroy()). The fix requires 'end' emitted, or ended with an empty buffer, otherwise ERR_STREAM_PREMATURE_CLOSE.

# Change
One hunk in `getEosOnCloseError` (lib/internal/streams/end-of-stream.js), corresponding to the fix's `onclose` hunk: the check `!isReadableFinished(stream, false)` (today's equivalent of `isReadableEnded`) is replaced by the old `!rState || !rState.ended`. The pipeline.js destroyer hunk is not reverted: that code has been rewritten, and the old destroyer behaviour does not map onto today's code.

# Failing test
parallel/test-stream-finished: `TypeError: Cannot read properties of undefined (reading 'code')`. The callback receives no error where ERR_STREAM_PREMATURE_CLOSE was expected. test-stream-pipeline still passes.
