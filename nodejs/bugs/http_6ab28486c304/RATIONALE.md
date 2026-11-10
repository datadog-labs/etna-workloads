# Rationale

**Bug:** For HTTP keep-alive connections, the server's parser kept `parser.incoming` pointing at the last
request after the response finished, so the IncomingMessage could not be garbage collected while the
socket stayed open (memory leak, nodejs/node#9668).

**Change (lib/_http_server.js):**
- Removed the `clearIncoming(req)` call in `resOnFinish` (fix hunk 2). Without it `parser.incoming` is never reset after the request finishes.
- Removed the now-unused `clearIncoming` helper (fix hunk 1, which added it; it is dead code without the call and would fail lint).

**Failing test:** `parallel/test-http-server-keepalive-end` fails: after `end`, `parser.incoming` is still `req` rather than `null` on the next tick (assert.strictEqual failure).
`test-http-server-keepalive-req-gc` still passes in this build (the GC check is not triggered by this change here).
