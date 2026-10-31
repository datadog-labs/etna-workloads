Reproducer for gh-116931: `TarFile.addfile()` with a non-zero-size regular-file TarInfo and no fileobj.

Clean interpreter: raises `ValueError: fileobj not provided for non zero-size regular file`.
Buggy interpreter: silently writes an incomplete entry and prints `no error`.
