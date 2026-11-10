# Rationale

Bug: `fs.read(fd, options, cb)` treated a `null` `options.buffer` as "not provided" (old code used `options.buffer || Buffer.alloc(16384)`), so it silently allocated a default buffer instead of throwing ERR_INVALID_ARG_TYPE.

Hunk (lib/fs.js, `read()`): the fix replaced `options.buffer || Buffer.alloc(16384)` with destructuring defaults (which only apply for `undefined`). Today's code uses `({ buffer = Buffer.alloc(16384) } = params ?? kEmptyObject)`; I reverted that line to `buffer = params?.buffer || Buffer.alloc(16384)`, restoring the falsy-fallback behaviour for null buffer. (Offset/length handling in today's code was already rewritten and not touched.)

Failing test: parallel/test-fs-read — `AssertionError: Missing expected exception: throws when options.buffer is null`.
