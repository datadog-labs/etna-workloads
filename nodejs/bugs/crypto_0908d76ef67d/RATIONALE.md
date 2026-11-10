# Bug
One-shot Ed25519/Ed448 verification (WebCrypto `subtle.verify`) accepted signatures whose public key or R component is a small-order point (e.g. the all-zero-S forgery with a small-order key), returning true instead of false.

# Change
`src/crypto/crypto_sig.cc`, `SignTraits::DeriveBits`, Verify mode: removed the `!key.hasSmallOrderEdDsaPoint(params.signature)` condition, so a successful `verifyOneShot` alone yields true. This corresponds to the fix's hunk adding `&& !HasSmallOrderEdDsaPoint(key, params.signature)` to the verify check in the same function (today the helper lives in ncrypto, so the original helper hunk does not apply; the helper is left unused rather than deleted).

# Failing test
`parallel/test-webcrypto-sign-verify-eddsa` -> `not ok 1` (small-order verify assertion expects `false`, gets `true`). Stable across two runs.
