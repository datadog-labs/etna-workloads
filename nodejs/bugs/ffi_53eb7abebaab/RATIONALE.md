# Re-introduced bug: premature GC of DynamicLibrary (fix 53eb7abe)

**Bug:** A function returned by `DynamicLibrary.getFunction()` did not keep its owning `DynamicLibrary` alive. If user code dropped the library and kept only the function, the library could be garbage collected, so later calls could hit a closed or freed library.

**Change (src/node_ffi.cc, `FFIFunctionInfo::FFIFunctionInfo`):** I removed `object->SetInternalField(kLibrary, library->object())`. The upstream fix added a `v8::Global<v8::Object> library` to `FFIFunctionInfo` (in node_ffi.h) and reset it in `CreateFunction` and `CleanupFunctionInfo` (node_ffi.cc). Today's code no longer has that struct or the weak-callback cleanup. `FFIFunctionInfo` is now a BaseObject, and the internal field is the equivalent strong library reference. Removing it matches the pre-fix state, where no reference existed. The `library` parameter is kept and voided, so the signature and build are unchanged.

**Failing test:** `ffi/test-ffi-dynamic-library` fails with this change, in the subtest 'FFI functions keep their owning library alive'. The assertion that failed was `assert.ok(ref.deref() instanceof ffi.DynamicLibrary)` (falsy value). I ran it twice and it failed both times. The test is already present in the tree.
