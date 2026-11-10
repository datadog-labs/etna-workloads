# Re-introduced bug: tls.convertALPNProtocols with ArrayBufferViews

**Bug.** `convertALPNProtocols` handled every ArrayBufferView with `Buffer.from(view)`. For
non-Uint8 typed arrays (Uint16Array, Float64Array, ...) that copies element values (truncated to bytes)
rather than the underlying bytes, and DataViews yield an empty buffer. So the ALPN buffer did not match the view's bytes.

**Hunks.**
1. `lib/tls.js` import: dropped `isUint8Array` (the fix added `isDataView`/`isUint8Array`; the current tree only had `isUint8Array`, now unused).
2. `lib/tls.js` `convertALPNProtocols`: the fix's separate Buffer/Uint8Array, DataView and generic-view branches
   (today: Uint8Array branch and a byte-range-slicing ArrayBufferView branch) are collapsed back into a single
   `isArrayBufferView(protocols)` branch using `Buffer.from(protocols)`, the pre-fix behaviour. The current
   `validateALPNBuffer` calls are kept (unrelated later addition).

**Failing test.** `parallel/test-tls-basic-validations` fails: at line 102 a
`TypeError [ERR_INVALID_ARG_VALUE]: The argument 'ALPNProtocols' contains truncated protocol. Received <Buffer 1f 61 61 ...>`
is thrown (element-wise copy of a wider typed array gives wrong bytes).
