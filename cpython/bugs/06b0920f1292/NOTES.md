Opens a blob on a 3-byte row and slices `blob[5:-5]`, which gives an empty slice with out-of-bounds indices.
Clean: prints `b''`. Buggy: the missing `len == 0` early return reaches `inner_read`, so a debug-build assertion fails (SIGABRT, status -6).
