# Re-introduced bug: negative BigInts silently accepted in crypto prime APIs

**Bug.** `generatePrime`/`generatePrimeSync` (`options.add`, `options.rem`) and `checkPrime`/`checkPrimeSync` (`candidate`) converted BigInts to buffers without checking the sign. A negative BigInt such as `-1n` gives the hex string `-1`, which `Buffer.from(..., 'hex')` silently turns into an empty buffer (effectively 0). No `ERR_OUT_OF_RANGE` was thrown.

**Change** (`lib/internal/crypto/random.js`, one hunk). I removed the `if (bigint < 0) throw new ERR_OUT_OF_RANGE(name, '>= 0', bigint)` guard from `unsignedBigIntToBuffer`. This corresponds to the fix hunk that added that guard. The fix's other hunks refactored the validation into `createRandomPrimeJob`, and the release already has that refactor, so they need no reversal. All callers (`options.add`, `options.rem`, `candidate`) go through this helper, so removing the guard brings back the old behaviour for all of them.

**Failing test.** `parallel/test-crypto-prime` reports `not ok`, and the result was the same on two runs. The test expects `ERR_OUT_OF_RANGE` with the message `The value of "options.add" is out of range. It must be >= 0. Received -1n`, and nothing is thrown.
