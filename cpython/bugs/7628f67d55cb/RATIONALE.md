# Rationale

## Changed: `Lib/unittest/mock.py`

Removed the `MagicMixin.reset_mock` override (it sits after `mock_add_spec`).
This reverses the fix's `+def reset_mock(self, /, *args, return_value=False, **kwargs)`
hunk, which added the guard that forces `return_value=False` for mocks whose
`_mock_name` is a magic name. Without it, `reset_mock(return_value=True)` goes
straight to `NonCallableMock.reset_mock` and wipes the configured return values
of magic methods such as `__str__` and `__hash__`, as before the fix.

The other fix hunk (whitespace in the `NonCallableMock.reset_mock` signature) is
cosmetic and not reverted.

## Oracle failure

`test_magic_mock_does_not_reset_magic_returns` (subtest `reset=True`) fails:
after `mm.reset_mock(return_value=True)`, `mm.__str__()` returns a `MagicMock`
rather than a `str` (`AssertionError: <class 'unittest.mock.MagicMock'> is not <class 'str'>`).
