# Rationale

Fix hunk reversed: `Lib/gzip.py` `compress()` (the fix removed the `if mtime == 0:` early return
delegating to `zlib.compress(..., wbits=31)`). v3.15.2 already had the simplified body, so only the
early return was re-added (before the zlib-header-rewriting code). With `mtime == 0` (also the
default now) the gzip header OS byte is whatever zlib writes (3 on Linux) instead of 255.

The `_create_simple_gzip_header` helper was not restored: the bug is the zlib delegation, which alone
reproduces the OS-byte inconsistency.

Oracle: `test.test_gzip.TestGzip.test_issue112346` fails for mtime=0 (OS byte 3 != 255).
