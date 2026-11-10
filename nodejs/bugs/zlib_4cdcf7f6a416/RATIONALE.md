# Re-introduced bug: zstd reset loses dictionary and params

**Bug.** `ZstdCompressContext::ResetStream()` and `ZstdDecompressContext::ResetStream()` recreated the zstd context through `Init()`. That discarded the dictionary and every parameter set through `SetParameter` (compression level, checksum flag, windowLog, windowLogMax). After `stream.reset()` the stream no longer used its initial options.

**Changes (all in `src/node_zlib.cc`).**
- Compress `ResetStream`: this corresponds to the fix's `ZSTD_CCtx_reset(..., ZSTD_reset_session_only)` rewrite. I replaced the session-only reset, pledged-size re-set and state clearing with `return Init(pledged_src_size_, {}, false);`. That creates a fresh `ZSTD_CCtx` with no dictionary and no params, which is the pre-fix behaviour. I kept the release's newer incomplete-frame check above it.
- Decompress `ResetStream`: this corresponds to the fix's `ZSTD_DCtx_reset(..., ZSTD_reset_session_only)` rewrite. I replaced it with `return Init(ZSTD_CONTENTSIZE_UNKNOWN, {}, reject_garbage_after_end_);`, which creates a fresh `ZSTD_DCtx` and drops the dictionary and params.

**Failing test.** The test file is `parallel/test-zlib-zstd-reset`, and I ran it twice with the same result. TAP reports `not ok`.
- Compress reset test: `AssertionError: Expected values to be strictly deep-equal`. The reset stream's output differs from the expected output.
- Decompress dictionary test: `Error: Data corruption detected`, code `ZSTD_error_corruption_detected`.
- Decompress params test: `AssertionError: Missing expected rejection`. The windowLogMax param was lost.
