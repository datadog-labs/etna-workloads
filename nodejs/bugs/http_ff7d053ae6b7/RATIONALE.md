# Re-introduced bug: socket not destroyed on parse error without 'clientError' listener

**Bug.** When the HTTP server hits a parse error and no `'clientError'` listener exists, the socket should be
destroyed (with the error, so the socket's `'error'` event fires) after the 400 response is written. Before the fix,
the response was sent with `socket.end()` followed by an early `return`, so the socket was only half-closed and
never destroyed; a peer that keeps its side open (allowHalfOpen) leaves the connection hanging and no error is emitted.

**Hunk (lib/_http_server.js, `socketOnError`).** Corresponds to the single implementation hunk of the fix, which
replaced `this.end(badRequestResponse); return;` with `this.write(badRequestResponse);` (falling through to
`this.destroy(e)`). In today's code the response is chosen via a switch, and the fix's form is `this.write(response)`.
I reverted it to `this.end(response); return;`, restoring the old behaviour (no destroy when the socket is writable).

**Failing test.** `parallel/test-http-server-destroy-socket-on-client-error` — "not ok", timeout (exitcode -15):
the server socket's `'error'` handler (`mustCall`) is never called and the client never gets 'end'.
