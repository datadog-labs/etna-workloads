# Re-introduced bug: scrypt option validation bypass via getters (nodejs/node#28836)

**Bug:** In `crypto.scrypt`/`scryptSync`, option values (N/cost, r/blockSize, p/parallelization) were validated by reading `options.X`, then read a second time to assign. An option object with a getter can return a valid value on the first read and an invalid one (e.g. `''`) on the second, bypassing validation and passing an arbitrary value to C++, where an assertion crashes the process.

**Change (lib/internal/crypto/scrypt.js, `check()`):** six hunks, one per parameter (N, cost, r, blockSize, p, parallelization). Each corresponds to the matching hunk of the fix, reversed: `validateUint32(options.X, name)` runs first, then `X = options.X`, so the validated value is not the one used. (Today's code differs slightly in `const has_N` declarations, so the reverse patch didn't apply verbatim.)

**Failing test:** `parallel/test-crypto-scrypt` fails ("not ok 1"). The regression block expects ERR_INVALID_ARG_TYPE when the final getter access returns `''`, but the process aborts instead: `Assertion failed: args[offset + 2]->IsUint32()` (exitcode -6), as in the original issue.
