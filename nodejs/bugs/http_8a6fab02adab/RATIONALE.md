# Re-introduced bug
Aborted HTTP messages (server `IncomingMessage` when the client disconnects, and client `IncomingMessage` when the socket closes mid-response) emit only `'aborted'` and `'close'`; no `'error'` event with `ECONNRESET`/'aborted' is emitted, so stream-based code (pipeline, finished) doesn't see the failure.

# Hunks
- lib/_http_server.js `abortIncoming`: fix added `req.emit('error', connResetException('aborted'))` (when listeners exist). Today the code is `req.destroy(new ConnResetException('aborted'))`, which delivers the error via `_destroy`/`onError`. Changed to `req.destroy()` so no error is emitted (old behaviour: only 'aborted' + 'close').
- lib/_http_client.js `socketCloseListener`: the fix added the same error emit for client responses. Today it is `res.destroy(new ConnResetException(...))`; changed to `res.destroy()`.

# Failing tests (all five oracle cases, stable over two runs)
test-http-abort-client, test-http-client-aborted-event, test-http-client-spurious-aborted, test-http-outgoing-message-capture-rejection, test-http-aborted fail: `common.expectsError`/mustCall for the expected 'error' (ECONNRESET, 'aborted') event is never called.
