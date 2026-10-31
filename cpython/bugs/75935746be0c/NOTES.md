A dataclass instance whose field refers to itself is compared with `c == c`.
Clean: the generated `__eq__` short-circuits on `self is other` and prints True.
Buggy: the shortcut is gone, so the comparison recurses infinitely and prints RecursionError.
