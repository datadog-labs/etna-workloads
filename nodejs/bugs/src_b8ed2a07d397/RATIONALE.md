# Re-introduced bug: gzip `{ windowBits: 8 }` null-message crash

**Bug.** `{ windowBits: 8 }` is valid for deflate but not gzip (zlib's gzip wrapper needs >= 9). When zlib init fails, the error path built a `CompressionError` with a null message (`ErrorForMessage(nullptr)`; zlib leaves `strm_.msg` null). Formatting that message dereferenced nullptr and segfaulted. Today's release reaches this via the lazy `InitZlib` failure, which is reported by `GetErrorInfo()`.

## Hunks
1. `src/node_zlib.cc`, `CompressionError` constructor: removes `CHECK_NOT_NULL(message)`. This reverses the fix's constructor hunk, so null messages are no longer caught early.
2. `src/node_zlib.cc`, `ZlibContext::GetErrorInfo()` default case: `ErrorForMessage("Zlib error")` becomes `ErrorForMessage(nullptr)`. This corresponds to the fix's `ErrorForMessage("zlib error")` hunk. Init was refactored to be lazy, so the equivalent spot is where a failed init surfaces now. With `strm_.msg == nullptr` the message stays null.
3. `lib/zlib.js`, `zlibNormalize`/windowBits range check: removes the later gzip-specific `min = Z_MIN_WINDOWBITS + 1`, so gzip accepts 8 again, as before the fix. Without this, JS rejects 8 before reaching C++ and the bug is unreachable. This is not a hunk of the original fix. It undoes the later JS guard that makes the path reachable.

## Failing test
`parallel/test-zlib` fails ("not ok 1 parallel/test-zlib") on two runs. The assertion `gzipSync(Buffer.alloc(0), {windowBits: 8})` expects `ERR_OUT_OF_RANGE` and no longer gets it. The init failure is also routed through the null-message path.
