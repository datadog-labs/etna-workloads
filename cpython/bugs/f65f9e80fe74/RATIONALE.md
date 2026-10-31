# Rationale

## Change
`tree/Lib/reprlib.py`, `recursive_repr.decorating_function`: removed the line
`wrapper.__type_params__ = getattr(user_function, '__type_params__', ())`.

This reverses the single implementation hunk of the fix, which added that line.
The surrounding code has moved on (`__annotate__` replaced `__annotations__`),
but the hunk still applies in spirit: the wrapper no longer copies
`__type_params__`, so it keeps the default empty tuple.

## Oracle failure
`test.test_reprlib.TestRecursiveRepr.test__type_params__` fails with
`AssertionError: 0 != 1`. The decorated generic `__repr__[T: str]` loses its
type params. The other cases pass.
