# Rationale

Fix hunk (Lib/reprlib.py): added `wrapper.__wrapped__ = user_function` in `recursive_repr`.

Change: in `tree/Lib/reprlib.py` I removed that same line (v3.15.2 still has it, after the `__type_params__` assignment). Without it, the wrapper returned by `recursive_repr()` has no `__wrapped__` attribute, which is the pre-fix behaviour.

Oracle: `test.test_reprlib.TestRecursiveRepr.test__wrapped__` fails with
`AttributeError: 'function' object has no attribute '__wrapped__'`.
