# Rationale

**Bug:** `util.inspect` of a Proxy (with `showProxy: false`) did not mark the object as proxied: it printed the target's formatting (`{}`, `[]`, `[Function: Date]`) instead of `Proxy({})`, `Proxy([])`, etc.

**Hunk:** `lib/internal/util/inspect.js`, `formatValue`. The fix wrapped the result of `formatRaw` in `Proxy(...)` when a proxy was seen. In today's code this is the `proxies` counter loop after `formatRaw`; I removed it so `formatValue` returns `formatRaw(...)` directly, as before the fix. (Revoked-proxy wrapping was left alone; it came later.)

**Failing tests** (stable over repeated runs): parallel/test-util-inspect-proxy, parallel/test-repl, parallel/test-assert-deep. Each expects `Proxy(...)` output but gets the bare target format, e.g. `util.inspect(new Proxy([], []))` gives `[]` instead of `Proxy([])`.
