# Re-introduced bug: http server connection list keeps freed parsers

**Bug.** Before the fix, a parser was removed from the server's ConnectionsList (`Pop`/`PopActive`) only inside `parser.close()`, not when `freeParser()` released it. If the parser was freed but not yet closed (close is deferred via setImmediate, or never happens), the stale parser stayed in the list. `server.close()` / `closeIdleConnections` then walked the list and hit a parser whose socket was already null, throwing a TypeError.

**Hunks.**
- `lib/_http_common.js`: removed the `parser.remove()` call in `freeParser` (fix hunk 1). Freed parsers are no longer unlinked.
- `src/node_http_parser.cc` `Parser::Close`: the Pop/PopActive block moved back into Close (fix hunk 2 reversed: the fix moved it from Close into Remove). The `Remove` method and its registration are left in place because today's code has changed, and they are now unused by JS. This is the pre-fix behaviour: unlinking happens only on close.

**Failing test.** `parallel/test-http-server-connection-list-when-close` fails on both runs:
`TypeError: Cannot read properties of null (reading '_httpMessage')` at `_http_server:720` (`connections[i].socket._httpMessage`).
