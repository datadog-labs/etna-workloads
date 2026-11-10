# Re-introduced bug: HTTP/2 client loses AsyncLocalStorage context (fix f67e45e0)

**Bug.** Client HTTP/2 streams did not capture the async context in which `client.request()` was called. Events (`response`, `data`, `end`) were emitted from the session's native callbacks, so `AsyncLocalStorage.getStore()` returned the context of the session's creation (or none) instead of the context of the request.

**Changes (all in lib/internal/http2/core.js)**
- Removed `new AsyncResource('PendingRequest')` and `stream[kRequestAsyncResource]` in `ClientHttp2Session.request` (fix hunk 3). With no resource stored, nothing can restore the request context. Also removed the now-unused `AsyncResource` import and `kRequestAsyncResource` symbol (fix hunks 1 and 2).
- `onConnect` is no longer wrapped in `reqAsync.bind(...)`, and the `requestOnError` nextTick is no longer bound either (fix hunk 4). Pending requests run in the connect-time context.
- `onSessionHeaders` emits with plain `process.nextTick(emit, ...)` instead of `reqAsync.runInAsyncScope` (fix hunk 2). The release also had a later `runInAsyncScope(() => stream.push(null))` branch. It could never fire without the resource, so I reduced it to `stream.push(null)`.

**Failing test.** `parallel/test-http2-async-local-storage` fails on both runs with `not ok 1`: the `response` handler's `assert.strictEqual(id, storage.getStore().id)` fails (`actual: 0, expected: 1`). The store is the connect-time `{id: 0}` instead of the request's `{id: 1}`.
