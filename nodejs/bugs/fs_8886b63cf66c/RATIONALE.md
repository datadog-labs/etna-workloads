# Re-introduced bug: fs.write with buffer length > INT32_MAX

**Bug:** `fs.write(fd, buf, offset, length)` no longer validates that `length` fits in int32. A length above INT32_MAX passes JS validation and reaches the native `WriteBuffer`. That function now accepts any safe JS integer, but `uv_fs_write` returns an int and cannot write more than INT32_MAX bytes. The user gets no `ERR_OUT_OF_RANGE` error.

## Hunks
1. `lib/internal/fs/utils.js`, `validateOffsetLengthWrite`: removed `validateInt32.withoutStackTrace(length, 'length', 0)`. This corresponds to the fix's JS hunk that added `validateInt32(length, 'length', 0)`. Without it, the int32 check is gone.
2. `src/node_file.cc`, `WriteBuffer`: `CHECK(args[3]->IsInt32())` and `As<Int32>()` became `CHECK(IsSafeJsInt(args[3]))` and `As<Integer>()`. This corresponds to the fix's C++ hunk, which reverted c380ee6. It restores the pre-fix, wider native check.

## Failing test
`parallel/test-fs-write-buffer-large` fails with `AssertionError [ERR_ASSERTION]: Missing expected exception (RangeError)`. The expected error was `ERR_OUT_OF_RANGE: The value of "length" is out of range. It must be >= 0 && <= 2147483647. Received 2147483648`. It failed on both runs.
