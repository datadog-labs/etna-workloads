repro.py starts a child Python whose function name and script filename contain Latin-1, BMP and astral characters. It then reads the child's stack with `_remote_debugging.RemoteUnwinder` and prints the function and file names.

The clean interpreter returns the exact names. The buggy one reads remote strings as raw bytes (assuming 1-byte ASCII layout), so the names come back as garbled strings full of NULs, and the lookup prints `False`.
