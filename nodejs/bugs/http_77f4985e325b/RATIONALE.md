# Re-introduced bug: http server timeout defaults (nodejs/node#45778)

**Bug:** `headersTimeout` always defaulted to 60s regardless of `requestTimeout`, and the validation was strict (`headersTimeout >= requestTimeout` threw). So `createServer({ requestTimeout: 20000 })` threw ERR_OUT_OF_RANGE, and equal values (10000/10000) were rejected.

**Changes (lib/_http_server.js, `storeHTTPOptions`):**
1. Default `headersTimeout = MathMin(60_000, requestTimeout)` -> `60_000` (fix hunk 2 reversed); removed the now-unused `MathMin` import (fix hunk 1 reversed).
2. Check `headersTimeout > requestTimeout` -> `>=` and message `<= requestTimeout` -> `< requestTimeout` (fix hunk 3 reversed).

**Failing test:** parallel/test-http-server-timeouts-validation:
`RangeError [ERR_OUT_OF_RANGE]: The value of "headersTimeout" is out of range. It must be < requestTimeout. Received 10000` (equal-values case, line 22).
