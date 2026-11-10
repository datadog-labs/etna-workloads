# Re-introduced bug: cross-realm SharedArrayBuffer validation

**Bug.** SharedArrayBuffer detection used a prototype check
(`ObjectPrototypeIsPrototypeOf(SharedArrayBuffer.prototype, V)`), which fails for
SABs from another realm (vm context). Cross-realm SAB-backed views were therefore
not recognised as shared and were accepted by WebCrypto (e.g. `subtle.digest`)
while same-realm ones were rejected.

**Why not a plain reversal.** `lib/internal/crypto/webidl.js` no longer has its own
`isSharedArrayBuffer`; validation moved to `lib/internal/webidl.js`, which uses
brand checks (`ArrayBufferPrototypeGetResizable` throwing on SAB).

**Hunks (all in lib/internal/webidl.js)**
1. Replaced the `isSharedArrayBuffer` import from `internal/util/types` with a local
   prototype-based `isSharedArrayBuffer` (and added `ObjectPrototypeIsPrototypeOf`
   primordial). Corresponds to the fix's removal of the local prototype-based helper
   in favour of the `internal/util/types` one.
2. `validateBufferSourceBacking` and `converters.BufferSource` catch blocks: when the
   brand check throws, only treat the buffer as a SAB if the (prototype-based)
   `isSharedArrayBuffer` says so; otherwise accept it. This restores the old
   behaviour where a cross-realm SAB was not identified as shared.

**Failing test.** `parallel/test-crypto-subtle-cross-realm` fails (stable over 2 runs):
`AssertionError [ERR_ASSERTION]: Expected values to be partially and strictly
deep-equal` — the cross-realm SAB `digest` no longer rejects, while the same-realm
one rejects with "2nd argument is a view on a SharedArrayBuffer, which is not allowed."
