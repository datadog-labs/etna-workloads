Writes a message to a GzipFile, calls flush(), and decompresses the partial output as raw deflate.
Clean: returns the full message (compressor is sync-flushed). Buggy: flush() doesn't flush the zlib compressor, so b'' is returned.
