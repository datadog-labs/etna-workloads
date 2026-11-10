# Re-introduced bug: unbounded http2 client originSet (CVE-2026-48619)

**Bug:** A malicious HTTP/2 server can send repeated ORIGIN frames with unique origins; the client-side `originSet` grows without bound for the life of the session.

**Change (one hunk, lib/internal/http2/core.js, `onOrigin`):** removed the `if (originSet.size >= session[kMaxOriginSetSize]) { session.destroy(new ERR_HTTP2_TOO_MANY_ORIGINS(...)); return; }` check inside the loop. This corresponds to the fix's `onOrigin` hunk; without it origins are added unconditionally, as before the fix. The other fix hunks (error code, option validation, `kMaxOriginSetSize` storage) are left intact since they are inert without the check in `onOrigin`. The `maxOriginSetSize` option is still validated but has no effect.

**Failing test:** `parallel/test-http2-origin-set-max-size` ("not ok", stable across 2 runs): the default-value case expects `ERR_HTTP2_TOO_MANY_ORIGINS` on the client and only 12 `origin` events, but no error is raised and origin events keep firing.
