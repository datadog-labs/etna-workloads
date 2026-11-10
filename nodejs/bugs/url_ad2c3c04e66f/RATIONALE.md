# Rationale

**Bug:** `urlToHttpOptions` built the options object only from the standard URL getters, so properties a user added to a URL object (e.g. `url.headers = {...}`) were dropped when `http.request(url)` converted it. Extended URL objects lost their extra options.

**Change (lib/internal/url.js, `urlToHttpOptions`):** removed the `...url, // In case the url object was extended by the user.` spread from the options literal. This corresponds to the fix's hunk that added `...url` (the fix's destructuring hunk is harmless and left in place, as today's code already has it). Without the spread, own enumerable props such as `headers` are not copied, restoring the old behaviour.

**Failing test:** parallel/test-http-client-request-options — `AssertionError [ERR_ASSERTION]: Expected values to be strictly equal` (the server sees no `foo` header). Failed on two consecutive runs.
