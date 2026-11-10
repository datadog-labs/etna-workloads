# Re-introduced bug: optimized buffer/arraybuffer signatures lose pointer-like conversions

**Bug.** The JS wrapper (lib/internal/ffi/fast-api.js) converts `buffer`/`arraybuffer` arguments (null, undefined, strings, memory-backed objects) to raw BigInt pointers. Before the fix, the native Fast API entrypoint was still generated with `buffer` argument types, so it expected a V8 buffer object and not the BigInt. Once the function was optimized, calls such as `asBuffer(0n)`, `null`, `undefined` or `'ffi'` therefore threw `Argument 0 must be a buffer or an ArrayBuffer`.

**Hunks** (the lib/ side of the fix is already present in this release, so only the C++ hunks needed reverting):
1. `src/node_ffi.cc`: reverses the fix hunk that added `CloneWithRawPointerArgNames(fn)`. `CreateFastFFIMetadata` again receives the original `*fn`, so buffer args stay typed `buffer` in the Fast API signature and no longer accept the converted BigInt pointers.
2. `src/ffi/fast.cc`: reverses the `SignatureNeedsFastBufferInvoke` hunk. It again accepts only pointer-like type names, not `buffer`/`arraybuffer`.
`CloneWithRawPointerArgNames` and `IsBufferTypeName` are left defined but unused.

**Failing test.** `ffi/test-ffi-fast-buffer` fails on both runs. The failure message is `TypeError: Argument 0 must be a buffer or an ArrayBuffer`.
