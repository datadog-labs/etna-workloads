Calls `f(0)` then `f(0, **{})` on an lru_cache'd function. Clean: hits=1, misses=1.
Buggy: the empty kwargs dict makes the C lru_cache build a different key, so hits=0, misses=2.
