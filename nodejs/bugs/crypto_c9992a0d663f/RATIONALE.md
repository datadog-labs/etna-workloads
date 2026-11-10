# Encrypted private -> public import bug

**Bug:** `crypto.createPublicKey()` ignored the `passphrase` option, so an encrypted private key PEM could not be imported as a public key (OpenSSL fails: "interrupted or cancelled", since no passphrase reaches the decoder).

**Change (lib/internal/crypto/keys.js, createPublicKey):** corresponds to the fix's keys.js hunk (which started destructuring `passphrase` and passing it to `handle.init`). Today's code destructures `passphrase` and passes it as the 5th arg; I stopped passing it (pass `null`), restoring the old behaviour. The fix's C++ hunk (arg count CHECK 4 -> 5) has no equivalent: today's `Init` uses a unified 6-arg CHECK for public/private, so no change is needed there.

**Failing test:** parallel/test-crypto-key-objects — `not ok`, `Error: error:07880109:common libcrypto routines::interrupted or cancelled` from the new encrypted-private-as-public check.
