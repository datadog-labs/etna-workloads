# Re-introduced bug: 787143bf3e3a ("src: pass resource object along with InternalMakeCallback")

## Bug description

`InternalMakeCallback()` used the receiver (`recv`, the internal native handle object)
as the async *resource* for the callback scope. It did not use the public resource that
was reported to `init` hooks. So while a native callback ran (for example an HTTP parser
callback for `http.get()`), `async_hooks.executionAsyncResource()` returned the internal
`HTTPParser` handle. It should have returned the `HTTPClientAsyncResource` /
`HTTPServerAsyncResource` object that `init()` received for the same async id. The
result was `executionAsyncResource() !== hooked[executionAsyncId()]`
(nodejs/node#32060). The fix added a separate `resource` parameter to
`InternalMakeCallback()` and made `AsyncWrap::MakeCallback()` pass the public resource
(`GetResource()` at the time).

## How today's code differs

* `InternalMakeCallback(env, resource, recv, ...)` still exists. It now also passes
  `resource` to the async-hooks callback trampoline (`args[1]`), and has more callers
  (`MakeSyncCallback`, which passes `process_object()`, and N-API `AsyncContext`,
  which passes `resource()`).
* `AsyncWrap::GetResource()` was removed. `AsyncReset()` now stores the public resource
  on the handle as `obj[resource_symbol]`. The C++ side passes `object()` as the
  resource, and the public-resource mapping (the job `GetResource()` used to do) now
  happens in JS: `executionAsyncResource()` calls `lookupPublicResource()` in
  `lib/internal/async_hooks.js`.

## Hunks

1. **`src/node_internals.h`: remove the `resource` parameter from the
   `InternalMakeCallback(Environment*, ...)` declaration.** This reverts the fix's
   `node_internals.h` hunk.

2. **`src/api/callback.cc`: definition of `InternalMakeCallback`.** The `resource`
   parameter is removed, and `InternalCallbackScope` gets `recv` again. The trampoline
   argument that carries the resource (`args[1]`) is now `recv` too, so the JS-side
   execution resource matches the native one. This reverts the fix's first
   `callback.cc` hunk (`scope(env, resource, ...)` → `scope(env, recv, ...)`). The
   receiver is used as the execution resource again.

3. **`src/api/callback.cc`: callers.** `InternalMakeCallback(env, recv, recv, ...)` in
   the public `MakeCallback` path goes back to `InternalMakeCallback(env, recv, ...)`.
   This reverts the fix's second `callback.cc` hunk. `MakeSyncCallback` (a newer caller)
   loses its explicit `process_object()` resource in the same way, so it falls back to
   `recv`, as the pre-fix code did.

4. **`src/async_wrap.cc`: `AsyncWrap::MakeCallback`** no longer passes a separate
   resource argument. This is the call-site half of the fix's `async_wrap.cc` hunk.

5. **`src/node_api.cc`: `AsyncContext::MakeCallback`** no longer passes `resource()`
   separately, so `recv` is used as the resource. This is a mechanical consequence of
   hunk 1, done the same way as hunks 3 and 4.

6. **`lib/internal/async_hooks.js`: `executionAsyncResource()`** returns the raw
   execution resource (the native handle object) without passing it through
   `lookupPublicResource()`. This is the other half of the fix's `async_wrap.cc` hunk
   (`object()` → `GetResource()`). Today the mapping from the internal handle object to
   the public resource lives here, not in `AsyncWrap::GetResource()`. Removing it gives
   back the pre-fix behaviour: the execution resource seen by user code is the internal
   handle `object()`, not the resource that `init` saw. Without this hunk, the C++ hunks
   alone would not change anything for `AsyncWrap`, because there `recv == resource ==
   object()`.

The build succeeds (`make -j8`, exit 0).

## Failing tests

`async-hooks/test-async-exec-resource-http-32060` fails with this change. I ran it twice
and it failed the same way both times:

```
not ok 1 async-hooks/test-async-exec-resource-http-32060
  AssertionError [ERR_ASSERTION]: Expected "actual" to be reference-equal to "expected":
  + actual - expected
  + <ref *3> HTTPParser {
  +   '0': null,
  +   '1': [Function: parserOnHeaders],
  ...
  +   Symbol(resource_symbol): HTTPClientAsyncResource {
  ...
  - <ref *3> HTTPClientAsyncResource {
  -   req: <ref *1> ClientRequest {
```

Inside the `http.get()` response callback, `executionAsyncResource()` returns the
internal `HTTPParser` instead of the `HTTPClientAsyncResource` that the `init` hook
received. This is exactly the symptom reported in nodejs/node#32060.
