# Re-introduced bug: 7a9635b094b11201c9098312c805f8f72ac775ed

## Description

`crypto.subtle.decrypt()` with AES-GCM (and AES-OCB) did not validate that the
supplied ciphertext was at least as long as the authentication tag before
subtracting the tag length from the data length. When the input was shorter
than the tag, the unsigned subtraction `data_len -= tag_len` underflowed,
producing a huge bogus length that was used for subsequent buffer operations,
crashing the process instead of rejecting the returned promise with an
`OperationError`, as required by the Web Crypto spec.

## Where the logic lives today

At the time of the original fix, the relevant logic lived in JavaScript, in
`lib/internal/crypto/aes.js` (`asyncAesGcmCipher`), which sliced the tag off
the decrypt input and needed an explicit length check before doing so. In the
current tree, that per-call tag handling has moved into native code: the
length check and the tag-splitting `data_len -= tag_len` arithmetic now live
in `src/crypto/crypto_aes.cc`, inside the function that implements
`AES_Cipher` for the decrypt path of GCM/OCB. The JS layer in
`lib/internal/crypto/aes.js` no longer performs tag-length bookkeeping itself,
so there is no equivalent JS hunk to revert; the fix's "data is too small"
check was effectively migrated to, and is now solely implemented by, the C++
guard.

## Hunk correspondence

- **Fix hunk:** adds, in `asyncAesGcmCipher`:
  ```js
  if (tagByteLength > tag.byteLength) {
    return PromiseReject(lazyDOMException(
      'The provided data is too small.',
      'OperationError'));
  }
  ```
  i.e. reject before slicing the tag off ciphertext shorter than the tag.

  **My change:** in `src/crypto/crypto_aes.cc`, inside the decrypt branch of
  the GCM/OCB tag-length handling, I removed the equivalent native guard:
  ```cpp
  if (data_len < tag_len) {
    return WebCryptoCipherStatus::FAILED;
  }
  ```
  leaving only `data_len -= tag_len;`. This is the current-code counterpart of
  the fix's length check: with it removed, `data_len -= tag_len` underflows on
  `size_t` when `data_len < tag_len`, reproducing the pre-fix out-of-bounds
  behaviour (crash) instead of a clean failure.

  (The fix's other hunk — rejecting the promise instead of throwing
  synchronously for an invalid `tagLength` value — was left untouched, since
  that is a distinct, still-correct JS-level check unrelated to the
  too-small-ciphertext crash.)

## Files changed

- `src/crypto/crypto_aes.cc`: removed the `data_len < tag_len` bounds check
  in the AES-GCM/OCB decrypt tag-splitting code.

No files under `lib/` needed changes, since the check this bug concerns has
been fully migrated to native code in this release; `lib/internal/crypto/aes.js`
no longer contains tag-length arithmetic to revert.

## Test results

Built with `make -j8` (success) and ran:

```
python3 tools/test.py -p tap -j 4 --shell out/Release/node \
  --temp-dir <scratch> \
  parallel/test-crypto-webcrypto-aes-decrypt-tag-too-small
```

Run twice, both times:

```
TAP version 13
1..1
not ok 1 parallel/test-crypto-webcrypto-aes-decrypt-tag-too-small
  ---
  duration_ms: 222.77700
  severity: crashed
  exitcode: -11
  stack: |-
  ...
```

The test crashes the process (SIGSEGV, exit code -11) instead of passing,
confirming the re-introduced underflow bug: decrypting with a 0-byte input
(shorter than the 16-byte default tag) no longer rejects with
`OperationError: The provided data is too small.` but instead causes an
out-of-bounds access and a crash.
