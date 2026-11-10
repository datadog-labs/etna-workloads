# Re-introduced bug: false 'aborted' on HTTP/2 push streams

**Bug.** A client-side push stream (created in `onSessionHeaders` for a PUSH_PROMISE) kept its writable side open. When the readable side closed, the stream was treated as prematurely closed and emitted `'aborted'` even though nothing was aborted.

**Hunk (lib/internal/http2/core.js, `onSessionHeaders`, push-stream `else` branch).** The fix added `stream.end()` right after `new ClientHttp2Stream(...)`. In today's code that call sits at the end of the branch, after the diagnostics-channel publishes and the `endOfStream` push(null). I removed that `stream.end()`. The writable side is no longer closed on receipt, which is the pre-fix behaviour.

**Failing test.** `parallel/test-http2-server-push-stream` fails on both runs with `AssertionError [ERR_ASSERTION]: function should not have been called at test/parallel/test-http2-server-push-stream.js:57`. That is the `stream.on('aborted', common.mustNotCall())` check.
