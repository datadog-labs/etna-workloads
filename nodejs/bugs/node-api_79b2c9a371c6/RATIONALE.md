# Re-introduced bug: node-api callback wrapper ignores pending exception

**Bug:** In `CallbackWrapperBase::InvokeCallback` (src/js_native_api_v8.cc), after the addon callback returns, the return value was set whenever it was non-null, even if an exception was pending. An addon (e.g. C++ wrapper with exceptions) may return an invalid `napi_value` when it throws, so V8 dereferenced a garbage handle (crash / failed V8 check).

**Change (single hunk):** corresponds to the fix's only implementation hunk. Today's code has `exceptionOccurred` plus a handler lambda (with an added terminatedOrTerminating check). I removed the `exceptionOccurred` flag and the custom exception handler (CallIntoModule uses its default HandleThrow), and the return value is set again whenever `result != nullptr`. This restores the pre-fix behaviour.

**Failing test:** `js-native-api/test_function/test` — crashes with SIGSEGV (exitcode -11) when `TestBadReturnExceptionPending` returns an invalid pointer (0xFFFFFFFFF) after throwing. The test tree already contains the fix's test. Failure was stable across two runs.
