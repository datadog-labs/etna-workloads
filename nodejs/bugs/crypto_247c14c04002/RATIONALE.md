# Rationale

**Bug:** `KeyObject.asymmetricKeyType` did not support EdDSA keys. Before the fix, `GetAsymmetricKeyType` had no `EVP_PKEY_ED25519`/`EVP_PKEY_ED448` cases and hit `default: CHECK(false)`, aborting the process for Ed25519/Ed448 keys.

**Change:** in the release the type-name switch lives in `deps/ncrypto`, which is out of scope. The only hunk is in `src/crypto/crypto_keys.cc`, in `KeyObjectHandle::GetAsymmetricKeyType`. It corresponds to the fix's `node_crypto.cc` hunk that added the `EVP_PKEY_ED25519`/`EVP_PKEY_ED448` cases. Removing those cases meant EdDSA fell to `CHECK(false)`, so the new code does `CHECK(false)` for names "ed25519"/"ed448". The `env.h` string additions have no equivalent, since the release no longer uses those strings.

**Failing test:** `parallel/test-crypto-key-objects` aborts (exit -6, `Assertion failed: false` in `KeyObjectHandle::GetAsymmetricKeyType`) at the Ed25519 `asymmetricKeyType` check. The failure is stable across repeated runs.
