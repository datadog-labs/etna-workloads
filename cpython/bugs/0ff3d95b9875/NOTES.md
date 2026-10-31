gzip.decompress() on data with missing/truncated trailer: clean raises EOFError
("Compressed file ended before the end-of-stream marker was reached"); buggy
raises struct.error (unpacking short trailer) instead.
