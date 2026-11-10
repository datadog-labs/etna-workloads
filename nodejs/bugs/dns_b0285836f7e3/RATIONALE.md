# Bug
`Resolver.getServers()` (and the server-caching in `setServers`) assumed `_handle.getServers()` always returns an array. When it returns `undefined`, `ArrayPrototypeMap(undefined, ...)` throws a TypeError instead of yielding an empty list.

# Changes (lib/internal/dns/utils.js)
- `getServers()`: removed the `|| []` fallback on `this._handle.getServers()` (fix hunk 1).
- `setServers()`: removed the `|| []` fallback when caching the original servers (fix hunk 2; in the current code this is the `orig = ArrayPrototypeMap(this._handle.getServers() || [], ...)` expression).

# Failing test
`parallel/test-dns-get-server` fails (not ok): after mocking `_handle.getServers` to return undefined, `resolver.getServers()` throws a TypeError rather than returning an empty array. Failure was stable across two runs.
