# Rationale (gh-75988, Lib/unittest/mock.py)

Hunks changed, both in `Lib/unittest/mock.py`:

1. `NonCallableMock.__get_return_value`: restored `if ret is DEFAULT:` (fix added `and self._mock_wraps is None`).
   A wrapping mock again auto-creates a child mock as its default `return_value` instead of leaving `DEFAULT`.
2. `CallableMixin._execute_mock_call`: removed the `_mock_delegate.return_value is not DEFAULT` check the fix added.
   Without it, a delegate (autospec'd function) return value is never consulted before falling through to `_mock_wraps`.

The `create_autospec` hunk (passing `wraps` through) is left as is; reverting the two above restores the bug.

## Failing oracle cases
- `test_wraps_calls`: `mock.return_value` is a Mock, not `sentinel.DEFAULT`.
- `test_create_autospec_wraps_function_type`: autospec'd function with `wraps` returns a MagicMock instead of the real result.
