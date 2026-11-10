# Re-introduced bug: N-API Buffer finalizer runs synchronously during GC

## Bug
Before upstream fix 3ca0df22, the finalize callback of an external N-API Buffer ran
directly from V8's GC (backing-store free) callback. Finalizers may call into JS, which
the engine forbids during GC: results are assertion failures or crashes, and thrown
errors surface synchronously from `global.gc()`. The fix deferred the callback via `SetImmediate()`.

## Change (src/node_buffer.cc only)
In today's tree the deferral no longer lives in `node_api.cc`'s `BufferFinalizer`
(which just calls `CallFinalizer()` and assumes it is safe to run JS); it lives in
`node::Buffer`'s `CallbackInfo::OnBackingStoreFree()`, which wraps `CallAndResetCallback()`
in `env_->SetImmediateThreadsafe(...)`. The single hunk replaces that
`SetImmediateThreadsafe` lambda with a direct `self->CallAndResetCallback()` call
(releasing `mutex_` first to avoid self-deadlock). This corresponds to the fix's
hunk removing the `SetImmediate()` in `FinalizeBufferCallback`, and restores the
pre-fix behaviour of invoking the finalizer synchronously inside GC.

## Failures
- `node-api/test_buffer/test`: not ok — AssertionError: Expected values to be strictly equal
  (the deleter count is already 1 right after `global.gc()`, where the test expects 0 until the immediate runs).
- `node-api/test_exception/test`: not ok — crashed, exitcode -11 (SIGSEGV; JS executed from the finalizer during GC).
Stable across repeated runs.
