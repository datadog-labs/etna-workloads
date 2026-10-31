Reproducer: SpooledTemporaryFile(max_size=2).writelines() with a generator that records `f._rolled` after each yield.
Clean: [False, True] (rolls over mid-iteration, per line). Buggy: [False, False] (rollover only checked after the iterator is exhausted, so buffering is unbounded). File content is b'xyz' in both.
