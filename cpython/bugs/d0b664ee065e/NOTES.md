repro.py subscripts a partially-specialized Generic alias with `Unpack[list[int]]` and `Unpack[List[int]]`.
Clean: both raise `TypeError: Unpack[...] must be used with a tuple type`.
Buggy: the first raises a bare AssertionError (from `assert arg.__origin__ is tuple` in typing.py), so the second case never runs.
