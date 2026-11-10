# http2: session tracking and graceful server close

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 609df89cd35ce68f40c75c0717e6635d928551ed applied to v26.13.0 (fuzzy).

Upstream commit message:

```
http2: session tracking and graceful server close

This change adds proper tracking of HTTP / 2 server sessions
to ensure they are gracefully closed when the server is
shut down.It implements:

- A new kSessions symbol for tracking active sessions
- Adding/removing sessions from a SafeSet in the server
- A closeAllSessions helper function to close active sessions
- Updates to Http2Server and Http2SecureServer close methods

Breaking Change: any client trying to create new requests
on existing connections will not be able to do so once
server close is initiated

Refs: https://datatracker.ietf.org/doc/html/rfc7540\#section-9.1
Refs: https://nodejs.org/api/http.html\#serverclosecallback

- improve HTTP/2 server shutdown to prevent race conditions

1. Fix server shutdown race condition
   - Stop listening for new connections before closing existing ones
   - Ensure server.close() properly completes in all scenarios

2. Improve HTTP/2 tests
   - Replace setTimeout with event-based flow control
   - Simplify test logic for better readability
   - Add clear state tracking for event ordering
   - Improve assertions to verify correct shutdown sequence

This eliminates a race condition where new sessions could connect
between the time existing sessions are closed and the server stops
listening, potentially preventing the server from fully shutting down.

- fix cross-platform test timing issues

Fix test-http2-server-http1-client.js failure on Ubuntu
by deferring server.close() to next event loop cycle.

The issue only affected Ubuntu where session close occurs
before error emission, causing the test to miss errors
when HTTP/1 clients connect to HTTP/2 servers.

Using setImmediate() ensures error events fire before
server close across all platforms while maintaining
recent session handling improvements.

PR-URL: https://github.com/nodejs/node/pull/57586
Fixes: https://github.com/nodejs/node/issues/57611
Refs: https://datatracker.ietf.org/doc/html/rfc7540#section-9.1
Refs: https://nodejs.org/api/http.html#serverclosecallback
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
Reviewed-By: Tim Perry <pimterry@gmail.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
```
