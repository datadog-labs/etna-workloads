# Re-introduced bug: cross-realm ArrayBuffer rejected in WebIDL BufferSource conversion

**Bug.** The WebIDL `BufferSource` converter rejected an `ArrayBuffer` from another realm (vm context, worker), because it used a prototype-chain check against this realm's `ArrayBuffer.prototype`. For example, `subtle.digest('SHA-256', vmBuffer)` threw `TypeError: ... 2nd argument is not instance of ArrayBuffer, Buffer, TypedArray, or DataView.`

**Today's code.** `lib/internal/crypto/webidl.js` no longer has `isNonSharedArrayBuffer`. The conversion now lives in `lib/internal/webidl.js`, where the converter uses the primordial `ArrayBufferPrototypeGetResizable` getter as a realm-independent brand check.

**Hunks (all in `lib/internal/webidl.js`).**
- Import `ArrayBufferPrototype` and `ObjectPrototypeIsPrototypeOf` from primordials. This corresponds to the fix's import changes: it removes `ArrayBufferPrototype` and adds `isArrayBuffer`, so reversing it restores the prototype import.
- In the `BufferSource` converter's ArrayBuffer branch, add `if (!ObjectPrototypeIsPrototypeOf(ArrayBufferPrototype, V)) throw`. This corresponds to the fix's `isNonSharedArrayBuffer` change. The original pre-fix body was `ObjectPrototypeIsPrototypeOf(ArrayBufferPrototype, V)`, which fails for cross-realm buffers. The restored check does the same, so cross-realm buffers are rejected again.

**Result.** `parallel/test-crypto-subtle-cross-realm` prints `not ok` on both runs. The failure is a TypeError created in `makeException`, with the "is not instance of ArrayBuffer..." message. I only grepped the TAP output for `not ok` and the `new TypeError(message)` line, so I did not read the full message text.
