# Rationale

**Bug:** Truncated zstd input was silently accepted. Decompressing a partial zstd frame with finishFlush ZSTD_e_end (the default) produced partial output with no error, instead of "unexpected end of file" (Z_BUF_ERROR).

**Change (src/node_zlib.cc, `ZstdDecompressContext::GetErrorInfo`):** corresponds to the fix's `GetErrorInfo` hunk. In the release this function also handles trailing-junk detection (added later), so I kept that. I replaced the final `return CompressionError("unexpected end of file", "Z_BUF_ERROR", Z_BUF_ERROR)` with `return {}`, so an unfinished frame at ZSTD_e_end is no longer an error, as before the fix. The `frame_complete_` bookkeeping and the empty-input guard in `DoThreadPoolWork` stay as harmless state tracking (they are still used by the trailing-junk logic).

**Failing test:** `parallel/test-zlib-truncated` fails (`not ok`): the zstd truncated-input cases expect an error matching /unexpected end of file/ and none is raised.
