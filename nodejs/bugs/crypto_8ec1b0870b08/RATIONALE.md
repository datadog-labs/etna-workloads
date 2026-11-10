# Re-introduced bug: WebCrypto EC SPKI export keeps compressed points

**Bug.** Exporting an EC public key as `spki` via WebCrypto returns the key in whatever point format it was imported with. A compressed-point SPKI (59 bytes for P-256) therefore comes back compressed. The WebCrypto spec requires the uncompressed form (91 bytes for P-256).

**Change.** The change is in `lib/internal/crypto/ec.js`, in `ecExportKey`, case `kWebCryptoKeyFormatSPKI`. The release has moved the fix from C++ (`ECKeyExportTraits::DoExport` in `src/crypto/crypto_ec.cc`) into JS. The fix's single implementation hunk added the uncompressed re-encoding of the EC key in the SPKI branch. I removed the JS equivalent. That is the check of the DER length against the expected length for the curve, plus the rebuild of the key from the raw uncompressed point. SPKI now returns `handle.export(kKeyFormatDER, kWebCryptoKeyFormatSPKI)` unchanged, which is the behaviour before the fix.

**Not changed.** The fix's test and WPT-status hunks are not reproduced, since only `lib/` and `src/` may be edited. Some imports in `ec.js` (e.g. `KeyObjectHandle`) may now be unused. I could not run eslint offline, so lint is unchecked.

**Result.** `parallel/test-webcrypto-export-import-ec` fails on two consecutive runs. The assertion is `deepStrictEqual`: actual is `Buffer(91)`, expected is `Buffer(59)`. The "actual" and "expected" labels in the output are swapped relative to the test's argument order. The test passes the 91-byte uncompressed buffer as its first argument, so the diff labels it "actual". The 59-byte buffer is what the broken export returned.
