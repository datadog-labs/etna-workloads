# Rationale

Fix hunk: `Enum.__repr__` gained `if not isinstance(self, Enum): return repr(self)`.
The bug: for `class E(S, Enum)` where `S` uses `metaclass=EnumMeta` but is not an Enum,
`E._value_repr_` ended up as `Enum.__repr__` (S's `__repr__` is the one copied from Enum),
so `repr(E.A)` called `Enum.__repr__(1)` and raised AttributeError.

In v3.15.2 the guard is not present, but `EnumType._find_data_repr_` avoids the problem
(a different path covers it): it returns `base._value_repr_` for any `EnumType` base.
I did not re-add or remove the guard (it was never in v3.15.2's `Enum.__repr__`); instead I reverted
the covering path in `Lib/enum.py`, `_find_data_repr_`:

    elif isinstance(base, EnumType):
->  elif isinstance(base, EnumType) and issubclass(base, Enum):

A non-Enum class with metaclass EnumMeta (`S`) is no longer recognised there, falls to the
`'__repr__' in base.__dict__` branch, and picks up `Enum.__repr__` as the "data repr". Ordinary enums are unaffected.

Oracle: `test_multiple_superclasses_repr` fails (24 test-class variants) with
`AttributeError: type object 'int' has no attribute '_value_repr_'`; nothing else in test_enum fails.
Note: check.sh reported all cases failing even on the unmodified tree (the harness is SQLite-oriented and
does not run CPython tests); I verified with a manual build and `python -m unittest test.test_enum`.
