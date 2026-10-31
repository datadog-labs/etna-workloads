Reproducer: uses the pure-Python `_pydecimal.Decimal` with a subclass `D(Decimal, H)` where `H.__hash__` returns 42.
Hashing `D('NaN')` should equal `object.__hash__(value)` (clean prints True). With the bug, `super().__hash__()` is used, which resolves to `H.__hash__` via the MRO, so the buggy build prints False.
