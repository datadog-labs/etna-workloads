# Re-introduced bug: http agent accepts non-string 'host' header

**Bug:** `calculateServerName()` in `lib/_http_agent.js` did not validate that the `host` request header is a string. An array (or other non-string) `host` header was processed as if it were a string instead of throwing `ERR_INVALID_ARG_TYPE`.

**Hunks (lib/_http_agent.js):**
1. Removed `validateString(hostHeader, 'options.headers.host')` in `calculateServerName`. This corresponds to the fix's added `typeof hostHeader !== 'string'` throw of `ERR_INVALID_ARG_TYPE`. The release expresses that check via `validateString`, so removing it restores the pre-fix behaviour.
2. Removed the now-unused `validateString` import. This corresponds to the fix's added `ERR_INVALID_ARG_TYPE` import, which is only needed by the check.

**Failing test:** `parallel/test-http-client-headers-host-array` fails on both runs with `AssertionError [ERR_ASSERTION]: http request should throw when passing array as header host`. `http.request()` no longer throws `ERR_INVALID_ARG_TYPE`.
