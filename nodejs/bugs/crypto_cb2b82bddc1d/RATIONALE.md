# randomInt range check regression

Bug: `crypto.randomInt` validated its range with `!(max >= min)`, so `max === min` (e.g. `randomInt(0)`, `randomInt(1, 1)`) was accepted although the interval [min, max) is empty. The error message for invalid input also read `>= ${min}` instead of saying max must be greater than min.

Hunk (lib/internal/crypto/random.js, `randomInt`): corresponds to the fix's single implementation hunk. Today's code has `if (max <= min) throw ERR_OUT_OF_RANGE('max', 'greater than the value of "min" (...)')`; I restored the pre-fix `if (!(max >= min)) throw new ERR_OUT_OF_RANGE('max', \`>= ${min}\`, max)`. Equal bounds are no longer rejected and the message reverts.

Failing test: parallel/test-crypto-random — the assertion on `randomInt(0, cb)` etc. no longer throws / the message mismatches (observed: message `... must be >= 0 ...` vs. expected `greater than the value of "min" (0)`).
