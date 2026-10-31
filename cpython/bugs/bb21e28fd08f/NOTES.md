Creates m.py with mtime 2**32-1, byte-compiles it once (so a .pyc exists), then calls
compileall.compile_file (no force), which packs the mtime into the expected pyc header.
Clean: prints True. Buggy: struct.error ('l' format requires -2**31 <= number <= 2**31-1),
because the injection packs the mtime as signed 32-bit instead of masking with 0xFFFFFFFF.
