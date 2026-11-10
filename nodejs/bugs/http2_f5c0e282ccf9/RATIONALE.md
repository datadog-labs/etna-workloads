# Re-introduced bug: Host treated as a connection header in HTTP/2

Bug: `Host` was rejected in HTTP/2 requests (`ERR_HTTP2_INVALID_CONNECTION_HEADERS`) because it was
treated as a connection-specific header, and was not a single-value header. The `getAuthority` helper
also ignored Host, so `request.authority` did not fall back to it.

Changes (all in lib/internal/http2/util.js; the compat.js/core.js getAuthority call sites already exist
in the release and stay, since getAuthority itself is where the fix's fallback lives):
1. `kSingleValueFields`: removed `HTTP2_HEADER_HOST` (fix hunk adding it to kSingleValueHeaders).
2. `isIllegalConnectionSpecificHeader`: re-added `case HTTP2_HEADER_HOST` (fix hunk removing it).
3. `getAuthority`: removed the Host fallback (fix hunk adding it), so only `:authority` is returned.

Failing tests with the change:
- parallel/test-http2-util-headers-list: `HTTP/1 Connection specific headers are forbidden: "host"`
  (expected no throw / single-value error for host).
- parallel/test-http2-compat-serverrequest-host: client.request with `host` header fails with the same error.
Both failed on two consecutive runs.
