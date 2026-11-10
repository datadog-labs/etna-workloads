# Re-introduced bug: parser existence check (upstream 3c83f934378c)

**Bug.** The HTTP server's end-of-request code dereferenced `socket.parser` after checking only `parser !== null`.
If `socket.parser` is `undefined` (e.g. the property was deleted), the check passes and `parser.<prop>` throws a TypeError.
The fix changed the check to a truthiness check.

**Why the hunk is re-expressed.** `resetHeadersTimeoutOnReqEnd` no longer exists in v26.13.0 (header timeouts moved into C++ ConnectionsList).
The surviving equivalent is `clearIncoming` in `lib/_http_server.js`, which runs on request end and reads `socket.parser`.

**Hunk (lib/_http_server.js, clearIncoming).**
- `req.socket?.parser` became `req.socket.parser`.
- `if (parser && parser.incoming === req)` became `if (parser !== null && parser.incoming === req)`.
This matches the fix's `if (parser !== null)` before the change. An `undefined` parser now passes the guard and throws.

**Failing test.** `parallel/test-http-server-delete-parser` fails, stable over 2 runs:
`TypeError: Cannot read properties of undefined (reading 'incoming')`.
