# Re-introduced bug: getRandomValues accepts DataView

Web Crypto `getRandomValues` should only accept integer TypedArrays. Before the fix it validated with `isArrayBufferView`, so a `DataView` was accepted and filled with random bytes instead of throwing TypeMismatchError.

## Changes (lib/internal/crypto/random.js)
1. Validation `!isTypedArray(data)` -> `!isArrayBufferView(data)`: reverses the fix's only implementation hunk (`isTypedArray` import is still used elsewhere, so the import hunk needs no change).
2. `TypedArrayPrototypeGetByteLength(data)` -> `data.byteLength`: today's code uses a primordial that throws for a DataView; the old code used a generic length so the DataView gets through to `randomFillSync`. Needed for the old behaviour to be reproduced.

## Failing test
parallel/test-webcrypto-random: "not ok" (the DataView case in the invalid-input list no longer throws the expected TypeMismatchError DOMException). Failed on two consecutive runs.
