Decodes with 1500 distinct nonexistent codec names, then checks whether `encodings._cache` stayed within 500 entries (the fixed `_MAXCACHE`).
Clean prints `True` (cache is cleared at the limit); buggy prints `False` (cache grows unbounded).
