# Re-introduced bug: queued HTTP agent requests lose async context / reuse handle resource

**Bug.** When `http.Agent` hits `maxSockets`, a request is queued. When a socket is later freed, the agent handed it straight to the queued request via `setRequestSocket`. It neither restored the request's original async context (so `AsyncLocalStorage` stores were wrong in callbacks) nor called `asyncReset` on the handle (so the handle kept its asyncId and was not wrapped as a `ReusedHandle`).

**Changes (all in `lib/_http_agent.js`).**
1. In the `free` handler, I removed the `req[kRequestAsyncResource]` branch. It is now just `setRequestSocket(this, req, socket)`. This matches the fix hunk at `@@ -127,7 +129,17`. Without the branch there is no `runInAsyncScope` and no `asyncResetHandle(socket)` for queued requests.
2. In `addRequest`, I removed `req[kRequestAsyncResource] = new AsyncResource('QueuedRequest')`. This matches the hunk at `@@ -284,6 +289,8`. The async context is no longer captured when a request is queued.
3. I removed the `AsyncResource` import and the `kRequestAsyncResource` symbol. This matches the first two hunks of the fix and avoids unused variables. I kept the `asyncResetHandle` helper because the free-socket path in `addRequest` still uses it, as the fix did.

**Failing tests (stable over 2 runs).**
- `async-hooks/test-async-local-storage-http-agent` fails.
- `async-hooks/test-http-agent-handle-reuse-parallel` fails.
- `async-hooks/test-http-agent-handle-reuse-serial` still passes.

I did not capture the exact assertion messages. The first test checks `asyncLocalStorage.getStore() === i`. The second checks that the reused handle is wrapped (`first.handle === second.handle.handle`).
