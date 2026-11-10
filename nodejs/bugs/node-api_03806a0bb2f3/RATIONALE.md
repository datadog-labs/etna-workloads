# Re-introduced bug: Node-API reference used after user finalizer deleted it

**Bug.** During env teardown, the finalizer of a reference may call `napi_delete_reference` on the very reference being finalized. If `Reference::Finalize` touches the object afterwards (unlinking, reading ownership), it is a use-after-free / double free. The upstream fix forced the ref weak and nulled the finalizer callback so the code after the user finalizer was safe. Today's code has been restructured (`Reference::Finalize`, `Finalizer::CallFinalizer` which already resets the callback before calling it), so the literal hunks do not apply.

**Change (src/js_native_api_v8.cc, `Reference::Finalize`).** The `Unlink()` and the `deleteMe` decision (read of `ownership_`) were moved from before `CallUserFinalizer()` to after it. This corresponds to the fix's hunk that makes the code following the user finalizer safe to access instance state (the "safe access after finalizer" guarantee, re-expressed for the current code): now the object is touched after userland may have deleted it, restoring the pre-fix defect.
The `_finalize_callback = nullptr` hunk is already embodied by `CallFinalizer()` resetting the callback first; it was left intact since removing it is unnecessary for the failure.

**Failing test.** `js-native-api/test_reference_double_free/test` — `not ok`, severity crashed, exitcode -11 (SIGSEGV), stable across runs.
