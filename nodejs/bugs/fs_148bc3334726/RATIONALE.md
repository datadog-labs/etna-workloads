# Re-introduced bug: fs.truncate() with negative length

**Bug:** `fs.truncate(path, len, cb)` passed a negative `len` unchanged to the ftruncate syscall, which fails with EINVAL. The other truncate APIs clamp negative lengths to 0.

**Hunk:** `lib/fs.js`, in `truncate()`. I removed `len = MathMax(0, len);` after `validateInteger(len, 'len');`. This reverses the fix's single implementation hunk. It had to be re-expressed because the surrounding code has changed (`validateFunction` and the vfs handlers are now there).

**Failing test:** `parallel/test-fs-truncate` fails in both runs. The failure is `AssertionError [ERR_ASSERTION]: ifError got unwanted exception: EINVAL: invalid argument, ftruncate`. It comes from the added test that calls `fs.truncate(file, -1, common.mustSucceed(...))`.
