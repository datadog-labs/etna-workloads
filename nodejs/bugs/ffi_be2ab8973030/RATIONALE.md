# Re-introduced bug: detached ArrayBuffers accepted as FFI pointers (nodejs/node#65083)

## Bug
`ffi.getRawPointer()` and FFI pointer/buffer argument conversion (generic path, Fast API path and JS wrapper) no
longer check for detached ArrayBuffers or views over them. A detached buffer has no backing store, so it was
silently turned into a null (0) pointer and passed to native functions instead of throwing `ERR_INVALID_ARG_VALUE`.

## Hunks (each reverts the matching hunk of the fix)
- `lib/internal/ffi/fast-api.js`: removed `getRawPointerArg()` and its now-unused primordial/type imports. The two call
  sites (`convertPointerArg`, `wrapWithRawPointerConversions`) call `getRawPointer()` directly, as before the fix.
  `isArrayBuffer` stays imported because other code still uses it.
- `src/ffi/data.cc` `GetRawPointer`: removed the `WasDetached()` checks for ArrayBuffer and ArrayBufferView.
  (The `ExportBytes` message change, "ArrayBuffer is detached", is only a message tweak and was left alone.)
- `src/ffi/types.cc` `ToFFIArgument`: removed the detached checks for ArrayBufferView and ArrayBuffer arguments.
- `src/ffi/fast.cc` `node_ffi_fast_buffer_data`: removed the detached checks, and so the per-argument errors, for views
  and ArrayBuffers. Today's code already keeps `isolate` declared at the top, so that part was left in place.

## Failing tests
`ffi/test-ffi-memory` and `ffi/test-ffi-fast-buffer` both report `not ok` on repeated runs.
Failure message: `AssertionError [ERR_ASSERTION]: Missing expected exception.` The detached buffer or view no longer
throws `ERR_INVALID_ARG_VALUE`.
