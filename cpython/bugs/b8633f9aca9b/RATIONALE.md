# Rationale

All changes are in `Lib/inspect.py`; they reverse the `inspect.py` hunks of fix.patch.

1. `_signature_get_user_defined_method`: restored the pre-fix form. It has no `follow_wrapper_chains` parameter and does no `unwrap()` before or after `_descriptor_get`. Only the raw method is checked against `_NonUserDefinedCallables`. v3.15.2 had a variant of the fixed code, with an `unwrapped_meth` check added later for `@warnings.deprecated`. That check is removed too, since it is the same defect.
2. `_signature_from_callable`: the `__call__`, `__new__` and `__init__` lookups no longer pass `follow_wrapper_chains`. This reverses the hunk that added it.
3. The final "object.__init__/__new__" check compares `obj.__init__`/`obj.__new__` directly, without `unwrap`. This reverses the last hunk.

## Effect
A class whose `__new__` or `__init__` is a `functools.wraps` wrapper, e.g. from `@warnings.deprecated`, is treated as an ordinary user-defined function. Its `follow_wrapped` setting is ignored. The signature comes out as `(*args, **kwargs)` instead of the real one.

## Failing oracle cases
`test_warnings.DeprecatedTests.test_inspect_class_signature` fails for several subtests: `<Signature (x, y)> != <Signature (*args, **kwargs)>` and `<Signature ()> != <Signature (*args, **kwargs)>`. 4 failures in total.
