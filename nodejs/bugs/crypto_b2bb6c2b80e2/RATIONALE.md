# Bug
Exporting a private key with a `passphrase` but no `cipher` is no longer rejected in JS validation (`parseKeyEncoding`), so the invalid combination reaches native code, which crashes/misbehaves instead of throwing a clean `ERR_INVALID_OPT_VALUE`/`ERR_INVALID_ARG_VALUE` TypeError.

# Change
`lib/internal/crypto/keys.js`, `parseKeyEncoding`: removed the `else if (passphrase !== undefined) throw ...('cipher' ... 'is required when a passphrase is specified')` branch inside `if (!isInput)`. This corresponds to the fix's added `} else if (passphrase !== undefined) { throw ... }` hunk (re-expressed for today's code, where the error is ERR_INVALID_ARG_VALUE with an extra message). The `cipher != null` restructuring in the fix is already present and unchanged.

# Failing test
`parallel/test-crypto-key-objects` fails ("not ok") on the new test case "Exporting an encrypted private key requires a cipher" since export with only a passphrase no longer throws the expected error.
