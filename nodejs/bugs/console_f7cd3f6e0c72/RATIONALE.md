# Re-introduced bug: console.dir / util.inspect crash on a revoked proxy

Inspecting a revoked Proxy (`console.dir(r.proxy)`, `util.inspect`, `util.format('%s', ...)`) should print `<Revoked Proxy>`. With the bug, `getProxyDetails` returns `null` (or `[null, null]` with showProxy) for a revoked proxy and the code does not handle it, so it dereferences null and throws a TypeError.

## Changes (all in lib/internal/util/inspect.js)
The release has restructured formatValue, so the fix's first hunk (the `<Revoked Proxy>` early return) is expressed in two places today. I removed both:
1. `formatValue`, `ctx.showProxy` branch: removed the `proxy[0] === null` -> `<Revoked Proxy>` return. This matches fix hunk 1.
2. `formatValue`, unwrapping `do { } while` loop: removed the `proxy === null` -> `<Revoked Proxy>` return, so `null` becomes `value` and is dereferenced later. This also matches fix hunk 1.
3. `hasBuiltInToString`: removed the `proxyTarget === null` -> `return true` guard. This matches fix hunk 2.

## Failing tests
- parallel/test-util-inspect-proxy: `TypeError: Cannot read properties of null (reading 'Symbol(nodejs.util.inspect.custom)')`
- parallel/test-console-issue-43095: not ok (the same crash)

Both failed on two consecutive runs.
