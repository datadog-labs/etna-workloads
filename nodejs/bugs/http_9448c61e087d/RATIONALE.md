# Rationale

**Bug:** `OutgoingMessage.prototype.setHeaders` read each header via `headers.get(key)`. For a `Headers` object with multiple `Set-Cookie` values, `get` joins them with a comma, so the response sent a single combined `set-cookie` header instead of separate ones. For a `Map` with an array value, the array was passed straight through, which is fine, but `Headers` input was broken.

**Change (lib/_http_outgoing.js, one hunk):** this corresponds to the fix's single implementation hunk. I replaced the `for (const {0:key,1:value} of headers)` loop, which collected `set-cookie` values into a `cookies` array and set them once, with the original `for (const key of headers.keys()) this.setHeader(key, headers.get(key))`. The comment block and the `cookies` handling are removed. This brings back the old behaviour: cookies are comma-joined (and repeated keys overwrite each other).

**Failing test:** parallel/test-http-response-setheaders. The new Headers-with-two-Set-Cookie case fails its assertion that `res.headers['set-cookie']` is an array of length 2.
