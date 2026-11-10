# Re-introduced bug: CVE-2026-58044 (http max header count not enforced)

**Bug.** The HTTP parser no longer rejects requests whose header count exceeds `server.maxHeadersCount`. Excess headers are silently accepted by the parser instead of failing with `HPE_HEADER_OVERFLOW` (431), so a request can carry an unbounded number of headers.

**Change (src/node_http_parser.cc, one hunk).** In `on_header_field`, I removed the `rv = TrackHeaderPair(); if (rv != 0) return rv;` call at the start of a new field name. This matches the fix's first hunk (the one that adds the call). The fix's other hunks add the `header_pairs_` counter, its resets and `TrackHeaderPair()` itself. Today's code has moved on (it caches `max_header_pairs_`), so those hunks don't reverse cleanly. They are inert without the call, and I left them in. With no caller, the counter never advances and the limit is never checked, which is the pre-fix behaviour.

**Failing tests.** `parallel/test-http-max-headers-count-overflow` fails every time. `common.mustCall` for `clientError` is never satisfied, and the server's `mustNotCall` handler runs because the request is accepted. `parallel/test-https-max-headers-count` failed in one of two runs. I did not capture its failure message. `parallel/test-http-max-headers-count` passed in both runs.
