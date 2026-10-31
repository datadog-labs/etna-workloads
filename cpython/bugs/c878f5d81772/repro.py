from collections.abc import Set
fs = frozenset({1, 2, 3})
print(hash(fs) == Set._hash(fs))
