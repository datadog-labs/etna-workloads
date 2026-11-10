# Re-introduced bug: ffi accepts detached ArrayBufferViews (nodejs/node#65085)

**Bug.** `ffi.exportArrayBufferView()` did not reject detached views. For a detached DataView the JS length check read `source.byteLength`, which throws a bare `TypeError` ("Cannot perform get DataView.prototype.byteLength on a detached ..."). For a detached typed array, `ArrayBufferViewContents::Read()` never recorded detachment, so the native code did not see it as detached. Only detached ArrayBuffers got `ERR_INVALID_ARG_VALUE`.

**Hunks.**
1. `src/util-inl.h`, `ArrayBufferViewContents::Read()`: removed `was_detached_ = abv->Buffer()->WasDetached();`. This reverses the fix's only C++ hunk. `WasDetached()` is now never true for views, so the detached check in `ExportBytes` (`src/ffi/data.cc`) cannot fire for them.
2. `lib/ffi.js`, `exportArrayBufferView()`: removed the detached-buffer guard and went back to the unconditional `if (len < source.byteLength)`. This reverses the fix's JS hunk. The unused primordials and type imports that the fix added are left in place, since lint is not part of this task. A detached DataView again hits the throwing `byteLength` getter.

**Failing test.** `ffi/test-ffi-memory` fails in both runs. The failure is an `AssertionError` ("Expected values to be strictly deep-equal"). The actual error is `TypeError: Cannot perform get DataView.prototype.byteLength on a detached or out-of-bounds ArrayBuffer`, where `ERR_INVALID_ARG_VALUE` is expected.
