repro.py writes a binary plist whose data object claims a 1<<40 byte length but is truncated, then loads it from a buffered and an unbuffered file.
Clean: InvalidFileException (reads in chunks). Buggy: MemoryError (single huge fp.read allocation).
