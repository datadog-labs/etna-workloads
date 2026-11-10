# Re-introduced bug: importKey required argument count

**Bug:** `SubtleCrypto.importKey()` requires 5 arguments per WebIDL (format, keyData, algorithm, extractable, keyUsages), but the check only required 4, so omitting `keyUsages` did not reject with `ERR_MISSING_ARGS`.

**Hunk:** `lib/internal/crypto/webcrypto.js`, in `importKeyImpl` (the fix's `requiredArguments(arguments.length, 4 -> 5)` hunk, now expressed via `prepareSubtleMethod(this, 'importKey', arguments.length, 5)`): changed 5 back to 4.

**Failing test:** `parallel/test-webcrypto-export-import` (not ok, stable over 2 runs): the new case `subtle.importKey('raw', keyData, {name:'HMAC',hash:'SHA-256'}, false)` no longer rejects with `ERR_MISSING_ARGS`.
