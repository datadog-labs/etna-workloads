# Rationale

In v3.15.2 the code from `Lib/warnings.py` lives in `Lib/_py_warnings.py`.

## Hunk changed
`Lib/_py_warnings.py`, `deprecated.__call__`: the generated `__new__` signature
went from `def __new__(cls, /, *args, **kwargs)` back to
`def __new__(cls, *args, **kwargs)`. This reverses the single implementation
hunk of the fix, which made `cls` positional-only. Without `/`, a user keyword
argument named `cls` (e.g. `class Foo(metaclass=MyMeta, cls='haha')`) collides
with the wrapper's `cls` parameter.

## Oracle failure
`test_warnings.DeprecatedTests.test_do_not_shadow_user_arguments` fails with
`TypeError: ...MyMeta.__new__() got multiple values for argument 'cls'`.
The other 204 tests pass.
