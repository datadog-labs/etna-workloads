repro.py writes a stored zip entry "Charge men!", reads 6 bytes, does `seek(1, os.SEEK_CUR)`, then `read(-1)`.

Clean: prints `b'men!'`. Buggy: prints `b''`. The injected code takes the fast-seek path for a ZIP_STORED entry even when the target is inside the read buffer. It also no longer updates `_compress_left` or `_eof`, so the following read sees EOF.

I could not run `./check.sh` (bwrap sandbox error), so I ran both interpreters directly. Both exit with status 0.
