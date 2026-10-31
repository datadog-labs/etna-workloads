# Rationale

Most of the fix (gh-132805) is still in v3.15.2, so only one piece is reverted.

## Change: `Lib/annotationlib.py`, `_Stringifier.__getitem__`, tuple branch

Fix hunk reversed: the `__getitem__` hunk that changed
`elts = [self.__convert_to_ast(elt) for elt in other]` into a loop that
collects each element's `extra_names` and passes them to `__make_new`.

The tuple branch now discards the `extra_names` returned by
`__convert_to_ast_getitem(elt)`. This is the same defect as before the fix:
non-constant values nested in a subscript tuple, such as `undef[str, undef2]`,
are replaced by `__annotationlib_name_N__` but never recorded.
Evaluating the resulting ForwardRef then raises
`NameError: __annotationlib_name_1__`.

## Failing oracle cases
- `TestStringFormat.test_getitem`: the FORWARDREF evaluate raises `NameError`.
- `TestForwardRefFormat.test_partially_nonexistent`: same `NameError`.
- `TestForwardRefClass.test_evaluate_undefined_generic`: the argument stays an
  opaque `ForwardRef('__annotationlib_name_1__')` instead of `int`.
