# Re-introduced bug: fs chown/lchown/fchown reject -1 (uid/gid)

Bug: the promise-based chown, lchown and fchown validated uid/gid as uint32, so -1 ("leave unchanged") was rejected with ERR_OUT_OF_RANGE (range ">= 0"). The C++ bindings also asserted `IsUint32()`, out of sync with the later signed-integer handling (upstream issue: abort).

Hunks:
- lib/internal/fs/promises.js (lchown, fchown, chown): `validateInteger(x, 'x', -1, kMaxUserId)` -> `validateUint32(x, 'x')` (plus re-adding the `validateUint32` import). Mirrors the fix's promises.js hunks in reverse.
- src/node_file.cc (Chown, FChown, LChown): `CHECK(IsSafeJsInt(args[n]))` -> `CHECK(args[n]->IsUint32())`. Mirrors the fix's C++ hunks (the release's code uses FromV8Value, so only the CHECKs were reverted).

Failing test: parallel/test-fs-promises (stable over 2 runs):
expected message 'It must be >= -1 && <= 4294967295. Received -2', got 'It must be >= 0 && <= 4294967295. Received -2'.
