# Rationale

## Bug
`generateKeyPair`/`generateKeyPairSync` validated `saltLength`, `divisorLength`, `primeLength` and `generator` as uint32, but the C++ side treats them as int32. Values in [2^31, 2^32-1] passed JS validation and overflowed to negative numbers in C++. Negative values were also reported with a different error (ERR_OUT_OF_RANGE instead of ERR_INVALID_ARG_VALUE).

## Change (lib/internal/crypto/keygen.js)
The release uses `validateInt32(x, name, 0)`, where the fix originally used `isInt32(x) && x >= 0`. I re-expressed the old uint32 check with today's validator in four places, each matching a hunk of the fix:
- rsa-pss `saltLength` -> `validateUint32(saltLength, 'options.saltLength')`
- dsa `divisorLength` -> `validateUint32(divisorLength, ...)`
- dh `primeLength` -> `validateUint32(primeLength, ...)`
- dh `generator` -> `validateUint32(generator, ...)`

## Failing test
`parallel/test-crypto-keygen` fails (`not ok 1`), stable over repeated runs. The new cases for 2147483648 and -1 no longer throw the expected `ERR_INVALID_ARG_VALUE`.
