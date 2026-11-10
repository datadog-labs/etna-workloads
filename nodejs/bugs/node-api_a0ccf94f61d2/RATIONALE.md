# Rationale

**Bug:** When a threadsafe function is aborted, the finalizer (`finalize_cb`) ran *before* the pending queue was drained. `call_js_cb` is invoked for each leftover item (with null env/js_cb) and may use the context, which the finalizer may already have freed, giving use-after-free / wrong ordering.

**Change (src/node_api.cc, `ThreadSafeFunction::Finalize`):** The fix split `EmptyQueueAndMaybeDelete` into `EmptyQueue` and `MaybeDelete` and called `EmptyQueue()` at the start of `Finalize()`, before the finalizer. In today's code the split already exists, so the reintroduced hunk moves `EmptyQueue()` from before the `finalize_cb` block to after it, just before `MaybeDelete()`. This restores the old order: finalizer, then drain queue, then maybe delete.

**Failing test:** `node-api/test_threadsafe_function_abort/test` fails (stable across 2 runs):
`node: ../binding.cc:51: void tsfn_finalize(...): Assertion `ctx->state == Context::State::kCalled' failed.`
