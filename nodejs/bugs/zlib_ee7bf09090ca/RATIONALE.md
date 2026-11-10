# Bug
Zstd replaces a configured pledged source size with the input size when the first
ZSTD_compressStream2() call uses ZSTD_e_end (the sync, single-shot path). Without Node
tracking consumed input, `zlib.zstdCompressSync(data, {pledgedSrcSize})` with a mismatched
size silently succeeds instead of failing with ZSTD_error_srcSize_wrong.

# Change (src/node_zlib.cc, ZstdCompressContext::DoThreadPoolWork)
- Removed the `input_pos` capture and the `consumed_src_size_ += input_.pos - input_pos`
  accumulation (fix hunk adding them in DoThreadPoolWork).
- Removed the `consumed_src_size != pledged_src_size_` check that set
  ZSTD_error_srcSize_wrong when the frame completed (fix hunk adding the else-if branch).
  The `consumed_src_size_` member and its Init/ResetStream bookkeeping are left in place
  (now unused) to keep the change minimal.

# Failing test
parallel/test-zlib-zstd-pledged-src-size: `AssertionError [ERR_ASSERTION]: Missing expected
exception.` at compressSyncWithPledgedSrcSize (expected ZSTD_error_srcSize_wrong, errno 72).
Failure was stable across two runs.
