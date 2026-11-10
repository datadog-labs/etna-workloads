# Rationale

**Bug.** Before the fix, CryptoKey `usages` were not de-duplicated or returned in a canonical order, and the ML-KEM usages came out in a non-canonical order (`encapsulateBits` before `encapsulateKey`, `decapsulateBits` before `decapsulateKey`). The release now stores usages as a bit mask. That makes duplicates structurally impossible, so only the ordering half of the defect can come back.

**Change** (`lib/internal/crypto/util.js`, `kCanonicalUsageOrder`). The two ML-KEM pairs are swapped to `encapsulateBits, encapsulateKey` and `decapsulateBits, decapsulateKey`.
- It corresponds to the fix's `ml_kem.js` hunk, which swapped the order in `getUsagesUnion(...)`. It also matches the `kCanonicalUsageOrder` the fix added to `util.js`, which lists `Key` before `Bits`.
- Mask bit positions and the mask-to-usages expansion both derive from this list. Swapping it therefore changes the `usages` reported for ML-KEM keys, and the `key_ops` too, since those come from the same expansion.

**Not re-introduced.** I did not bring back duplicate usages. The fix's other hunks (passing `usagesSet`, `getSortedUsages`, and so on) have no counterpart in the mask-based code.

**Failing tests.** Both oracle cases fail on every run (two runs):
- `parallel/test-webcrypto-keygen`
- `parallel/test-webcrypto-deduplicate-usages`

Failure message for both:
`actual: [ 'encapsulateBits', 'encapsulateKey' ], expected: [ 'encapsulateKey', 'encapsulateBits' ]`
