# Re-introduced bug: spawn uid/gid not validated as int32

Bug: `child_process.spawn` only checked that `options.uid`/`options.gid` were integers, not that they fit in int32. A value such as `2 ** 63` passed JS validation and hit `CHECK(uid_v->IsInt32())` in src/process_wrap.cc, aborting the process instead of throwing a TypeError.

Hunks (lib/child_process.js, in `normalizeSpawnArguments`):
- uid check: the fix replaced `Number.isInteger` with `isInt32` (today's code: `validateInt32`). I restored `!NumberIsInteger(options.uid)` throwing `ERR_INVALID_ARG_TYPE('options.uid','integer',...)`.
- gid check: same, for `options.gid`.
- Import: added `NumberIsInteger` from primordials and removed the now-unused `validateInt32` import (lint).

Failing test: parallel/test-child-process-spawn-typeerror — process aborts with `Assertion failed: uid_v->IsInt32()` at process_wrap.cc:219 (test line 81, `spawn(cmd, [], { uid: 2 ** 63 })`).
