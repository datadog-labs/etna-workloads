# Rationale

**Bug:** `CryptoKey` lacked a `Symbol.toStringTag`, so `String(key)` / `key.toString()` gave `[object Object]` instead of `[object CryptoKey]`.

**Change:** `lib/internal/crypto/keys.js`: removed the `[SymbolToStringTag]: { __proto__: null, configurable: true, value: 'CryptoKey' }` entry from the `ObjectDefineProperties(CryptoKey.prototype, {...})` call. This corresponds to the fix's single implementation hunk (which added the same entry; in today's code it lives inside the lazily-created class factory rather than at module level).

**Failing test:** `parallel/test-webcrypto-keygen` fails (stable over 2 runs): `key.toString()` returns `[object Object]`, not `[object CryptoKey]` (strictEqual assertion).
