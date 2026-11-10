# Re-introduced bug: multiple destroy() calls (fix 311e12b9)

Bug: destroy() on an already-destroyed stream was not a noop. It recorded the new error in `errored` and then either invoked the callback with that error or emitted a fresh 'error' event on nextTick, so later destroy(err) calls produced extra/late errors and callback errors.

Hunks (both in lib/internal/streams/destroy.js):
1. destroy(): moved `checkError(err, w, r)` back before the already-destroyed check, and in that branch restored `if (cb) cb(err); else if (err) nextTick(emitErrorNT)`. Corresponds to the fix hunk that moved the check to the top and made it `cb()` only / noop.
2. errorOrDestroy(): removed the early `return` when the stream is already destroyed (fix hunk adding it).

Other fix hunks (_tls_wrap, fs streams, the callback/emitClose restructuring) are not applicable or already behave differently in the current code, so were not reverted.

Failing tests (stable over 2 runs): test-net-socket-destroy-send, test-http2-server-stream-session-destroy, test-file-write-stream, test-file-write-stream2, test-stream-readable-destroy, test-stream-writable-destroy (flaky-order but fails), test-stream-pipeline.
