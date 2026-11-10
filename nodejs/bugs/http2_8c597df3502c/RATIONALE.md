# Re-introduced bug: http2 compat API throws on `connection` header

**Bug.** With the HTTP/2 compatibility API, `res.setHeader('connection', 'x')` was stored and later made the core
`respond()` throw `ERR_HTTP2_INVALID_CONNECTION_HEADERS`. The fix ignores such headers (except `trailers`) and emits
an `UnsupportedWarning` once.

**Changes (all in lib/internal/http2/compat.js)**
- Removed the `else if (!isConnectionHeaderAllowed) connectionHeaderMessageWarn()` branch in `assertValidHeader`
  (fix hunk 2): no warning is emitted.
- Removed the early `return` for disallowed connection headers in `[kSetHeader]` (fix hunk 4; today's code also has the
  same check in `[kAppendHeader]`, removed too): the header is stored again, so it reaches core and throws.
- Removed `statusConnectionHeaderWarned`, `isConnectionHeaderAllowed`, `connectionHeaderMessageWarn` and the now-unused
  `HTTP2_HEADER_CONNECTION` import (fix hunks 1 and 3: the helpers added by the fix) to avoid dead code/lint errors.

**Failing test.** `parallel/test-http2-server-set-header` fails (stable over 2 runs):
`TypeError [ERR_HTTP2_INVALID_CONNECTION_HEADERS]: HTTP/1 Connection specific headers are forbidden: "connection"`.
