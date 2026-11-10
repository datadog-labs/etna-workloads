# Re-introduced bug: external buffer finalizers run from the GC weak callback (c1ee70ec)

**Bug.** Buffers/ArrayBuffers created with a finalizer (`node::Buffer::New(..., callback, hint)`, `napi_create_external_buffer`) had their finalizer (typically `free(P)`) run from Node's own weak GC callback. That happens before V8 has dropped the pointer from its global array-buffer table, so a later allocation that reuses P can hit `Check failed: result.second`. The finalizer also ran synchronously inside GC rather than from a task on the JS thread after V8 released the BackingStore.

**Change (src/node_buffer.cc only).**
- Fix hunk "CreateTrackedArrayBuffer / BackingStore deleter calls OnBackingStoreFree": restored the old empty BackingStore deleter. The `CallbackInfo` is created after the ArrayBuffer and no longer passed as the deleter arg.
- Fix hunk "remove WeakCallback, add OnBackingStoreFree + SetImmediateThreadsafe": restored the `WeakCallback` (kParameter weak persistent) that calls the user callback, adjusts external memory and deletes `this`. This removes `OnBackingStoreFree`, `CallAndResetCallback`, the mutex and the threadsafe immediate.
- Fix hunk "CleanupHook": `Clean()` is back to detaching the buffer and calling `WeakCallback` directly.
- The `data == nullptr` special case is removed, because the old code did not need it.
- I did not revert the `napi_create_external_arraybuffer` hunk. The code there has diverged since the fix, and the Buffer path already reproduces the bug.

**Failing test.** `node-api/test_buffer/test` fails on both runs:
`AssertionError [ERR_ASSERTION]: Expected values to be strictly equal: actual: 1, expected: 0`.
After `global.gc()` the deleter call count is already 1, because the finalizer ran synchronously in GC instead of in a later tick. `addons/null-buffer-neuter/test` still passes.
