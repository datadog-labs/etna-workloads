# Rationale

Bug: the https server used its own requestTimeout default (120 s) instead of the shared default
used by the http server (the upstream fix made https match http's default). So `https.createServer()`
reported a different requestTimeout than `http.createServer()` and could drop slow requests earlier.

Hunk (lib/https.js, in `Server`): corresponds to the fix's lib/https.js hunk
(`this.requestTimeout = 120 * 1000`). In today's code the default comes from `storeHTTPOptions`
(300000), so I re-added the https-specific override `if (opts.requestTimeout === undefined)
this.requestTimeout = 120 * 1000;`. This restores the https-specific default.
The fix's `_http_server.js` hunk was only a comment change, so no hunk is needed for it.

Failing test: parallel/test-https-server-request-timeout
  AssertionError: actual: 120000, expected: 300000 (test-https-server-request-timeout.js:18)
