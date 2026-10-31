# Rationale

Changed `Lib/typing.py`, `_UnpackGenericAlias.__repr__`. It now returns
`'*' + repr(self.__args__[0])` again, as it did before the fix. The fix hunk
had replaced this line with `f'typing.Unpack[{_type_repr(self.__args__[0])}]'`.
The code in v3.15.2 is the same as in the fix, so this is a direct reversal.
The fix's other hunks only touched tests, a docstring and NEWS, so nothing else needed changing.

Oracle cases that fail: 7 in `test_typing`, including
`UnpackTests.test_usage_with_kwargs`. It gets `*<class 'test.test_typing.Movie'>`
instead of `typing.Unpack[test.test_typing.Movie]`. The TypeVarTuple repr tests
also fail, because they get `*Ts` instead of `typing.Unpack[Ts]`.
