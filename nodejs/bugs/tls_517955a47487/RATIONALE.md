# Re-introduced bug: JSStreamSocket (formerly StreamWrap) does not close its wrapped stream

Bug: when a JSStreamSocket is destroyed, the wrapped stream is not destroyed, so the
peer never sees "end"/"close". Likewise, when the wrapped stream closes, the wrapper is not destroyed.

The file is now lib/internal/js_stream_socket.js (was lib/internal/wrap_js_stream.js).

Hunks (both in that file, each reverting one fix hunk):
1. Removed the `stream.once('close', () => this.destroy())` listener in the constructor
   (fix hunk 1). The wrapper no longer closes when the underlying stream closes.
2. Removed `this.stream.destroy()` from `doClose()` (fix hunk 2). Destroying the wrapper
   no longer destroys the wrapped stream.

Failing tests (stable over 2 runs, build succeeded):
parallel/test-tls-destroy-stream and parallel/test-wrap-js-stream-destroy both report "not ok"
(mustCall expectations for 'close'/'end' are not met).
