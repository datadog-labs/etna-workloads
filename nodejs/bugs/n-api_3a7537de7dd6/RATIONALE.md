# Rationale

**Bug:** `napi_make_callback` with an `napi_async_context` ran the callback with the *receiver* (`recv`) as the async resource (the one seen by `executionAsyncResource()`). It should use the resource object that was given to `napi_async_init`, which is the resource async init was emitted with.

**Change (src/node_api.cc, `AsyncContext::MakeCallback`):** `node::InternalMakeCallback` now gets `recv` as its resource argument instead of `resource()`. This corresponds to the fix hunk that routes `napi_make_callback` through `AsyncContext::MakeCallback`, which passes `resource()`. Before the fix, `node::MakeCallback(isolate, recv, ...)` used the receiver as the resource. The release has since refactored `AsyncContext`, so the old behaviour is restored in that one argument instead of reversing the whole diff.

**Failing tests:**
- `node-api/test_async_context/test`: `hook_result.resource` is not reference-equal to `executionAsyncResource()`.
- `node-api/test_async_context/test-gcable-callback`: the resource is not the `{foo:'bar'}` object (actual `undefined`, expected `'bar'`).
- `node-api/test_make_callback/test-async-hooks`: `executionAsyncResource()` is `process` instead of `resource`.
