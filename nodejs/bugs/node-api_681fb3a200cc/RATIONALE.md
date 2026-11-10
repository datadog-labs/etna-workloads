# Bug
Exceptions thrown from JS inside thread-safe-function callbacks (call_js_cb) and tsfn finalizers were swallowed (stay pending / ignored) instead of being reported as 'uncaughtException' (the fix routes them via CallbackIntoModule, which triggers the uncaught exception policy).

# Change (src/node_api.cc)
- ThreadSafeFunction::DispatchOne: `env->CallbackIntoModule<false>(...)` -> `env->CallIntoModule(...)`. Corresponds to the fix hunk changing `CallIntoModule` -> `CallbackIntoModule<false>` for call_js_cb; restores the old behaviour where the exception is not emitted.
- ThreadSafeFunction::Finalize: `env->CallFinalizer<false>(...)` -> `env->CallIntoModule(finalize_cb...)`. Corresponds to the fix hunk for the tsfn finalize_cb (also CallIntoModule before the fix).
The other hunks (options flag, Work complete, BufferFinalizer, env destructor) are left intact since the release has been restructured.

# Failing test
node-api/test_threadsafe_function/test_uncaught_exception: 'uncaughtException' handlers (mustCall) never invoked for the callback/finalizer errors. The two finalizer tests still pass (they use CallFinalizer<true>, untouched).
