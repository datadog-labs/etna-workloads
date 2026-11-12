# Rationale
All changes are in src/src/common/gzip_file_system.cpp. Today's code has already been refactored (state machine, FinalizeRead), so the fix is re-introduced by undoing its gzip-side hunks.

1. `MiniZStreamWrapper::Initialize` (read path): replaced `GZipReadExact(...)` for the 10-byte header with a single `child_handle->Read` plus `NumericCast`. This undoes the fix's hunk that added GZipReadExact. A short read now yields a truncated header, so the stream is rejected as "not a GZIP stream".
2. Same function, EXTRA field: the checked `GZipReadExact(..., 2) != 2` is replaced by a bare `Read` of 2 bytes. This undoes the fix's xlen hunk.
3. `MiniZStreamWrapper::Read`: when `sd.refresh` is set, I restored the old check "if available <= GZIP_FOOTER_SIZE then Close(); return true". This undoes the fix's replacement of that logic with the incremental FOOTER/HEADER state machine. A truncated footer or header at a member boundary is now silently treated as end of stream instead of throwing "Unexpected end of GZIP stream".

## Oracle results (etna-check)
- FAIL GZIP reads tolerate short input reads: IO "Input is not a GZIP stream: short-read.gz"
- PASS GZIP reads tolerate short reads at member boundaries
- FAIL GZIP rejects truncated member boundaries: IOException not thrown (test line 164)
- PASS GZIP string decompression rejects a header-only stream with FNAME

2 of 4 oracle units fail. The other two still pass with these hunks.
