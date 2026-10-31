Creates an empty tar archive in memory, then calls `TarFile.next()` on it in stream mode ("r|") and normal mode ("r").
Clean: prints `None` for both. Buggy: the missing `offset == 0` check makes it seek to -1 (error / wrong result) instead of returning None.
