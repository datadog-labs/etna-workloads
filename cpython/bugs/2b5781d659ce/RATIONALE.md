# RATIONALE

## Change: `Lib/typing.py`, `_type_repr`
Removed the `if isinstance(obj, tuple): return '[' + ', '.join(_type_repr(t) for t in obj) + ']'`
branch. This reverses the fix's added hunk (the tuple special case "for `repr` of
types with `ParamSpec`"). The other fix hunks (GenericAlias early return, `'...'`
and FunctionType handling) now live in `annotationlib.type_repr`, which is
untouched. Without the branch, a tuple of ParamSpec arguments falls through to
`annotationlib.type_repr` -> `repr(tuple)`, so the pre-fix output is back:
`C[(int, str), bool]` instead of `C[[int, str], bool]`.

## Oracle
Run directly with a python built from the tree (`python -m test test_typing`):
9 failures, including `GenericTests.test_repr_3` (the fix's new test) with
subtests such as `MyCallable[[int], bool]` rendering as `MyCallable[(int,), bool]`.

Note: `./check.sh` reported all 732 cases failing even on the unmodified-injection
baseline (with the fix logic restored), so its result here is uninformative;
I verified with a manual build instead.
