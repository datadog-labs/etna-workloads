# Re-introduced bug: vm proxy callbacks cannot throw (nodejs/node#33806)

Bug: the contextify interceptors (setter, descriptor, definer) in src/node_contextify.cc assumed sandbox operations never fail. If a user-defined setter/getter on the sandbox threw, the interceptor hit `.Check()`/`.ToLocalChecked()` on an empty Maybe/MaybeLocal and the process aborted (fatal error) instead of propagating the exception.

Hunks (all in src/node_contextify.cc; today's code uses Intercepted return values, so the fix is re-expressed):
- PropertySetterCallback: `sandbox->Set(...).IsNothing()` early return -> `.Check()` (fix hunk 1: `USE(...)` -> `.Check()`).
- PropertyDescriptorCallback: `GetOwnPropertyDescriptor(...).ToLocal(&desc)` guard -> `.ToLocalChecked()` (fix hunk 2).
- PropertyDefinerCallback: `result.FromMaybe(false)` -> `result.ToChecked()` (fix hunk 3: DefineProperty result checked).

Failing test: parallel/test-vm-context-property-forwarding ("not ok"): the `prop = 42` with a throwing setter aborts the process with a V8 fatal error (OnFatalError) rather than throwing 'test error'. Stable over two runs.
