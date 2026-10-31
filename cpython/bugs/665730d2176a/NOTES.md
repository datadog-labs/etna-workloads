Calls `decompress(b'')` on a `BZ2Decompressor` created via `__new__` without `__init__`.
Clean: prints `b''`. Buggy: crashes (uninitialized lock/state, segfault or assertion).
