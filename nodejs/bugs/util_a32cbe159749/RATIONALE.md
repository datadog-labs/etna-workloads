# Re-introduced bug: util.inspect triggers proxy traps (a32cbe1597)

**Bug:** `util.inspect` only looked at proxy internals when `showProxy` was true. With `showProxy: false` it inspected the Proxy object directly, so handler traps (get, ownKeys, getPrototypeOf, ...) ran and the custom inspect function on the target was not reached transparently.

**Change (lib/internal/util/inspect.js, formatValue):** `getProxyDetails(value, !!ctx.showProxy)` became `ctx.showProxy ? getProxyDetails(value, true) : undefined`. This matches the fix's hunk that moved the unconditional proxy check ahead of the other checks. The old code only did the check inside `if (ctx.showProxy)`. Today's code has extra Revoked Proxy and nested-proxy handling, which is now only reachable with showProxy, as before the fix.

**Failing test:** parallel/test-util-inspect-proxy fails with `Error: get`, thrown from the handler's `get` trap during `util.inspect(proxyObj)`. Two runs gave the same result.
