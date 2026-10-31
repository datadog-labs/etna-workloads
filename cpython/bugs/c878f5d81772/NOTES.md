repro.py compares hash(frozenset({1,2,3})) with collections.abc.Set._hash on the same frozenset.
Clean prints True. The buggy build prints False, because the injection drops the `h ^= (h >> 11) ^ (h >> 25)` shuffle step from Set._hash.
