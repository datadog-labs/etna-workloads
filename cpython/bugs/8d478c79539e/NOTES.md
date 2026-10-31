Hashes `typing._UnionGenericAlias` and compares to `hash(Union)`.
Clean: prints True. Buggy: `__hash__` is missing (metaclass defines `__eq__` only), so it prints `TypeError: unhashable type: ...`.
