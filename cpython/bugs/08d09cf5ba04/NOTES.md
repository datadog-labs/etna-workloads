Calls gzip.compress(..., mtime=0 and 42) and prints the mtime field and OS byte of the header.
Clean: OS byte is always 255. Buggy: with mtime=0 it delegates to zlib, so the OS byte is zlib's value (3 on Linux).
