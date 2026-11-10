# Bug
DecompressionStream('deflate'/'gzip') silently accepted trailing junk after the end of the compressed stream instead of erroring with ERR_TRAILING_JUNK_AFTER_STREAM_END (TypeError).

# Change
Single hunk in lib/internal/webstreams/compression.js: `createInflate({rejectGarbageAfterEnd: true})` -> `createInflate()` and `createGunzip({rejectGarbageAfterEnd: true})` -> `createGunzip()`. This corresponds to the fix's hunk in compression.js that added `rejectGarbageAfterEnd: true` for deflate and gzip. The zlib.js/errors.js parts of the fix are already in the release in a rewritten form (and are still used by other formats), so only the option passing was reverted.

# Failing test
parallel/test-zlib-type-error: "not ok" (stable over 2 runs); the promise does not reject ("Expected promise to reject") since trailing data is ignored.
