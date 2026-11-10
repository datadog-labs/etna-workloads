# Re-introduced bug: http2 allowHTTP1 + Upgrade (2a0fcdbc883d)

**Bug.** An `Http2SecureServer` with `allowHTTP1: true` has no `shouldUpgradeCallback`, so the HTTP/1 parser path (`parserOnIncoming` in lib/_http_server.js) throws `server.shouldUpgradeCallback is not a function` when an HTTP/1 `Upgrade` (e.g. WebSocket) request arrives.

**Why not a plain reversal.** The fix added the default callback in `Http2SecureServer`'s constructor. In v26.13.0 that hunk is redundant, because `storeHTTPOptions` (which http2 also calls) already installs the default. So removing the hunk alone changes nothing.

**Hunks.**
1. lib/internal/http2/core.js: removed the `this.shouldUpgradeCallback = function() {...}` block from the `allowHTTP1` branch. This is the direct reverse of the fix hunk.
2. lib/_http_server.js: the default callback moved out of `storeHTTPOptions` into a new `setDefaultShouldUpgradeCallback()`. `http.Server` calls it, and it is exported. `storeHTTPOptions` now only stores a user-supplied callback. This restores the pre-fix layout, where http2 got no default.
3. lib/https.js: `https.Server` calls `setDefaultShouldUpgradeCallback` after `storeHTTPOptions`, so http and https behave as before.

**Failing test.** `parallel/test-http2-allow-http1-upgrade-ws` fails with `TypeError: server.shouldUpgradeCallback is not a function`. It failed on both runs. `test-http-upgrade-server` and `test-https-simple` still pass.
