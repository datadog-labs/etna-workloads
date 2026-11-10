# Re-introduced bug: CVE-2026-58040 (https: bind identity checks to session reuse)

## Bug
A per-request `checkServerIdentity` passed to `https.request`/`https.get` (with an agent that has none of its own) was not
bound to the connection. Such requests shared the agent's TLS session cache and socket pool with requests that use other
callbacks. A resumed TLS session or a keep-alive socket could skip the new callback, so a rejecting `checkServerIdentity`
was never run.

## Change (lib/https.js, one hunk)
In `request()`, I removed the block that tagged `options` with `kPerRequestCheckServerIdentity`. This matches the fix's
`request()` hunk, which added that block. Without the tag, the other fix hunks never take effect. Those are
`getName` cache-key separation, `reuseSession` disabling session caching, and `keepSocketAlive` returning false. The
pre-fix behaviour is back. The other fix hunks are still in the file as dead code, because the code around them changed
since the fix and reversing them would be noisier than useful.

## Failing test
`parallel/test-https-agent-checkserveridentity-reuse` fails: `assert.deepStrictEqual(sessionAgent._sessionCache.map, {})`
throws an AssertionError because the session is cached despite the per-request callback. Two runs gave the same result.
