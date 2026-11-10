# Re-introduced bug: ieee-p1363 ignored by createVerify().verify()

**Bug.** `Verify.prototype.verify` (crypto.createVerify) with `dsaEncoding: 'ieee-p1363'` failed to verify valid signatures: the P1363 signature was converted to DER, but the original, unconverted bytes were passed to the verification routine, so verification always failed.

**Hunk (src/crypto/crypto_sig.cc, `Verify::VerifyFinal` JS binding).** Corresponds to the fix's hunk in `Verify::VerifyFinal(args)` that changed the call from passing `hbuf.data()/hbuf.length()` to passing the `signature` ByteSource (the DER-converted one). Today's code already takes a `ByteSource`, so the pre-fix behaviour is restored by passing `hbuf.ToByteSource()` (the raw input) instead of `signature` (the converted one). The signature of the C++ `VerifyFinal` was already refactored, so the other fix hunks (signature/header) need no counterpart.

**Failing test.** `parallel/test-crypto-sign-verify` fails (`not ok 1`) at the new `crypto.createVerify('sha1').update(data).verify(opts, sig)` ieee-p1363 assertion (expected true, got false). Stable across two runs.
