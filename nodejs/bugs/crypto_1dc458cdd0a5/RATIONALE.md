# Bug
scrypt `maxmem` was limited to 32 bits (uint32) instead of any safe integer (53 bits), so `maxmem: 2 ** 52` was rejected.

# Hunks
- lib/internal/crypto/scrypt.js: `validateInteger(maxmem, 'maxmem', 0)` -> `validateUint32(maxmem, 'maxmem')` (fix's JS hunk reversed; unused `validateInteger` import dropped).
- src/crypto/crypto_scrypt.h: `uint64_t maxmem` -> `uint32_t maxmem` (fix's `uint32_t`->`uint64_t` hunk reversed).
- src/crypto/crypto_scrypt.cc: `CHECK(IsNumber())` -> `CHECK(IsUint32())` and read via `As<Uint32>()->Value()` instead of `IntegerValue` (reverse of the CHECK/value hunk).

# Failing test
parallel/test-crypto-scrypt (stable over repeated runs):
`RangeError [ERR_OUT_OF_RANGE]: The value of "maxmem" is out of range. It must be >= 0 && <= 4294967295. Received 4_503_599_627_370_496`
