# Rationale

The bug (gh-108469): `ast.unparse` did not support PEP 701 f-strings. It unparsed
f-string expression parts with a nested unparser that avoided backslashes (and
hence quotes), and raised `ValueError` if a backslash remained.
In v3.15.2 the code lives in `Lib/_ast_unparse.py`; only that file is changed.

- `__init__` / nested unparser (`_unparse_interpolation_value`): restore the
  `_avoid_backslashes=True` keyword and attribute, reversing the fix's
  `type(self)(_avoid_backslashes=True)` -> `type(self)()` hunk.
- `_write_ftstring`: restore the pre-fix early branch that buffers the whole
  f-string and writes it with `_write_str_avoiding_backslashes` when
  `_avoid_backslashes` is set (reverse of the removed `visit_JoinedStr` block).
- `_write_interpolation`: restore the `"\\" in expr` check raising
  `ValueError("Unable to avoid backslash in f-string expression part")`
  (reverse of the removed check in `visit_FormattedValue`).

I did not revert the later quote-selection logic in `_ftstring_helper`.

Result: `./check.sh` fails 12 `test_unparse` cases with that `ValueError`
(e.g. the PEP 701 round trips and `test_fstring_backslash`).
