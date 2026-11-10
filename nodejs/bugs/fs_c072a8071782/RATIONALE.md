# Re-introduced bug: fs fds validated as uint32 instead of int32

Bug: fs functions accepted fds in [0, 2**32) instead of [0, 2**31-1]. Values above INT32_MAX passed validation and were truncated to a negative int when handed to libuv. The range error message also said `< 4294967296`.

In the current release the per-function `validateUint32(fd)` calls in lib/fs.js no longer exist. Validation is centralised in `getValidatedFd` (JS) and `GetValidatedFd` (C++, used by close/fstat/ftruncate etc.), so the hunks were re-expressed there.

## Hunks
1. `lib/internal/fs/utils.js` `getValidatedFd`: `validateInt32(fd, propName, 0)` -> `validateUint32(fd, propName)`. Corresponds to the `validateInt32(fd,'fd',0)` -> `validateUint32(fd,'fd')` hunks in lib/fs.js (all fd functions).
2. `src/util.cc` `GetValidatedFd`: upper bound `INT32_MAX` -> `UINT32_MAX`, message `<= 2147483647` -> `< 4294967296`. This is the C++ counterpart (the same check in the release is done natively for close/fstat/etc.), restoring the old uint32 range and message.

## Failing tests
- parallel/test-fs-fchown: expected `... It must be >= 0 && <= 2147483647. Received -2`, got `... It must be >= 0 && < 4294967296. Received -2`.
- parallel/test-fs-utimes: expected `<= 2147483647. Received -1`, got `< 4294967296. Received -1`.
