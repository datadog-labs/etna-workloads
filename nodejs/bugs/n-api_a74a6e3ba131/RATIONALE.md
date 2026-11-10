# Re-introduced bug: N-API finalizers run synchronously inside GC

**Bug.** Node-API finalizers were invoked directly from the GC callback instead of from a
`SetImmediate()` callback. User finalizers could therefore run (and throw) while the stack
was not set up for JS, corrupting the async hook stack or aborting the process.

**Change (src/node_api.cc, `node_napi_env__::EnqueueFinalizer`).**
Today's code already has the fix's idea in a different form: `EnqueueFinalizer` schedules
`DrainFinalizerQueue()` through `node_env()->SetImmediate(...)`. This corresponds to the
fix's hunk in `node_napi_env__::CallFinalizer` (node_api.cc), which wraps the finalizer call
in `SetImmediate`, and to the hunks in js_native_api_v8.cc/.h that route `RefBase::Finalize`
through `CallFinalizer`. I removed the SetImmediate scheduling (and the
`finalization_scheduled` + Ref/Unref bookkeeping) and now drain the queue immediately
when a finalizer is enqueued from GC, restoring the old synchronous-from-GC behaviour.

**Failing tests.**
- js-native-api/test_exception/testFinalizerException: assertion failure (the child process
  does not report "Error during Finalize" as the fixed code does)
- js-native-api/test_general/testFinalizer: fatal error (OnFatalError) from running finalizers in GC
- js-native-api/test_reference/test: fatal error in GC
