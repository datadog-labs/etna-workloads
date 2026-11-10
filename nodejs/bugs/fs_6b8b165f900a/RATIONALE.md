# Re-introduced bug: fs rejects negative-zero fd (nodejs/node#37122)

**Bug:** `-0` is a valid fd (0) but was rejected with `ERR_OUT_OF_RANGE`, e.g. `fs.fstat(-0, cb)`. The fix added `getValidatedFd`, which maps `-0` to `0`.

**Why not a plain reversal:** in this release the fd validation of most fs functions moved into C++ (`GetValidatedFd` in src/util.cc); `fs.fstat` no longer validates in JS.

## Hunks
1. `lib/internal/fs/utils.js`: removed the `ObjectIs(fd, -0) -> return 0` special case (and the now-unused `ObjectIs` import) from `getValidatedFd`. This matches the fix's `getValidatedFd` hunk, so the JS-validated paths (ftruncate etc.) lose the `-0` normalisation.
2. `src/util.cc` `GetValidatedFd`: treat `-0` (`fd == 0 && signbit`) as out of range. This is the old behaviour where `-0` was not accepted as an fd. It is what makes `fs.fstat(-0)` fail, as in the fix's test hunk.

## Failing test
`parallel/test-fs-stat` fails (`not ok`) in repeated runs: `fs.fstat(-0, common.mustSucceed())` gets `ERR_OUT_OF_RANGE` ("The value of "fd" is out of range...").
