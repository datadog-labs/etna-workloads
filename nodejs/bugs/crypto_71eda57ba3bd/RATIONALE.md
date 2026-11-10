# Rationale

**Bug:** `subtle.importKey()` accepted an empty `usages` list when importing `secret` or `private` keys. The WebCrypto spec requires a SyntaxError in that case. Before the fix, Node returned the key without checking.

**Change:** `lib/internal/crypto/webcrypto.js`, in `importKeySync`. I removed the post-import block that threw `SyntaxError: Usages cannot be empty when importing a ${type} key.` when the result was `secret` or `private` and its usages mask was 0.
- Corresponds to the fix's added `if ((result.type === 'secret' || ...) && result.usages.length === 0) throw ...` block. The release has refactored the surrounding code into `importKeySync`, so only this block needed removing.

**Failing tests:** test-webcrypto-export-import, -cfrg, -ec and -rsa fail. The assertion expects a rejection with `'Usages cannot be empty when importing a private key.'` (or `secret key`), but the import resolves. The sign-verify tests still pass.
