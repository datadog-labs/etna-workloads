`repro.py` writes a file containing a non-ASCII byte, then reads it with `fileinput.FileInput(inplace=True, encoding='ascii', errors='replace')` and prints a line to the redirected stdout.

Clean: `readline()` returns `'Initial text �'` and the file is rewritten as `b'New line ?\n'`.
Buggy: `errors` isn't passed to `open()` in inplace mode, so a `UnicodeDecodeError` is raised and the file is left empty (`b''`).
