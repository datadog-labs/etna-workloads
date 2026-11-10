# Re-introduced bug: subtle.getPublicKey error for secret keys

**Bug:** `crypto.subtle.getPublicKey()` called with a secret (symmetric) key rejected with
`InvalidAccessError` instead of `NotSupportedError`. Only the error name was wrong; the message
was unchanged.

**Hunk:** `lib/internal/crypto/webcrypto.js`, in `getPublicKeyImpl`. This corresponds to the single
implementation hunk of the fix. The code now reads the key type into a `type` variable, so the fix
looks different today. I replaced the conditional name
`type === 'secret' ? 'NotSupportedError' : 'InvalidAccessError'` with the constant
`'InvalidAccessError'`. That is the pre-fix behaviour for every non-private key.

**Failing test:** `parallel/test-webcrypto-get-public-key` (not ok, stable across 2+ runs):
```
AssertionError [ERR_ASSERTION]: Expected values to be strictly deep-equal:
  message: 'key must be a private key',
+ name: 'InvalidAccessError'
- name: 'NotSupportedError'
```
