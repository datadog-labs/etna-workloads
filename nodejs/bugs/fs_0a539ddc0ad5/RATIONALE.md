# Re-introduced bug: fs chown/lchown/fchown reject uid/gid of -1

**Bug.** `fs.chown`, `lchown`, `fchown` (and sync variants) validated uid/gid with `validateUint32`, so the valid range was `0..2**32-1`. `-1` (the POSIX "leave unchanged" value) was wrongly rejected with ERR_OUT_OF_RANGE, and the error message said `>= 0 && <= 4294967295`.

**Change (lib/fs.js only; fs/promises left untouched, as the fix did not touch it).** The release now has a `kMaxUserId` constant from `internal/constants`. The six `validateInteger(x, 'x', -1, kMaxUserId)` pairs in chown, chownSync, lchown, lchownSync, fchown, fchownSync were replaced by `validateUint32(x, 'x')`. This corresponds to the fix's six chown/lchown/fchown hunks. The import hunk was re-expressed: `validateUint32` was added to the validators import and the now-unused `kMaxUserId` import was removed.

**Failing test.** `parallel/test-fs-fchown` fails (stable over 2 runs): expected message `It must be >= -1 && <= 4294967295. Received -2`, actual `It must be >= 0 && <= 4294967295. Received -2`.
