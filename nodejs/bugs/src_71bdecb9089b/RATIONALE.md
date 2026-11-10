# Re-introducing nodejs/node#42713 (fixed by 71bdecb9089b, "src: let http2 streams end after session close")

## The bug

When an HTTP/2 session has been gracefully closed (`session.close()`, GOAWAY sent)
and its last stream finishes (e.g. a response that ends with trailing headers),
the stream-close notification arrives *from inside the nghttp2 stack* (from
`nghttp2_session_mem_send`/`mem_recv` callbacks via `Http2Session::OnStreamClose`).
Before the fix, the stream teardown that followed, including the
"is the closed session now empty, so destroy it?" decision, ran synchronously on
that nghttp2 stack. At that point nghttp2 still had pending work (data still to
write/read, e.g. trailers or a GOAWAY), so the session was torn down or the
decision was taken at the wrong moment. Trailers could be lost, or the session
might never finish closing, leaving the connection hanging. The 2022 fix made the
close path stop re-entering nghttp2 synchronously: in `OnStreamClose` it deferred
the work with `SetImmediate` while `nghttp2_session_want_write()` was true.

## How the code looks in v26.13.0

The C++ deferral hunk from the fix is no longer in `src/node_http2.cc`.
`OnStreamClose` calls `stream->Close(code)` and the JS callback directly. Upstream
replaced it with a different mechanism that addresses the same problem:

* `Http2Session::HasPendingData()` (want_write/want_read) is checked in JS
  `Http2Session[kMaybeDestroy]`.
* `ongracefulclosecomplete` notifies JS once nghttp2 has nothing left to write.
* `Http2Stream._destroy()` no longer calls `session[kMaybeDestroy]()` inline. It
  delays the call with `setImmediate` "so we don't do it on the nghttp2 stack".

The last item is the direct counterpart of the fix's hunk: it is what keeps the
session-close decision that follows a stream close from re-entering, or running
inside, the nghttp2 stack.

## The change (one hunk)

`lib/internal/http2/core.js`, `Http2Stream._destroy()`:

```diff
-    // pending streams. Delay with setImmediate so we don't do it on the
-    // nghttp2 stack.
-    setImmediate(() => {
-      session[kMaybeDestroy]();
-    });
+    // pending streams.
+    session[kMaybeDestroy]();
```

This corresponds to the single implementation hunk of the fix in
`Http2Session::OnStreamClose` (`src/node_http2.cc`): "Don't close synchronously in
case there's pending data to be written ... `env->SetImmediate(...)`". Removing
the deferral brings the old behaviour back. The session-teardown logic that
follows a stream close again runs synchronously inside the nghttp2 callback that
reported the close, while nghttp2 still has pending I/O for the session. In the
oracle test, the client stream closes while nghttp2 is still processing the
received HEADERS(trailers)+GOAWAY bytes. `kMaybeDestroy` runs right then, sees
that the session still has pending nghttp2 work and returns, and no later
opportunity to destroy the session comes. The closed session is never destroyed
and the socket never closes, so the stream cannot end cleanly after the session
close. That is the defect the fix removed. No test, build file or file outside
`lib/`/`src/` was modified.

## Failing test

`parallel/test-http2-trailers-after-session-close` fails stably (3/3 runs):

```
not ok 1 parallel/test-http2-trailers-after-session-close
  ---
  severity: fail
  exitcode: -15
  stack: |-
    timeout
```

The client's data, response and trailers are received. The client
session is never destroyed, so `client.socket.on('close')` never fires and the
process does not exit (killed by the test runner timeout). On the clean release
the test passes (`ok 1`, about 130 ms).
