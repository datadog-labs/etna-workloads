# Rationale

In v3.15.2 `Union` lives in C (`Objects/unionobject.c`); `typing._deduplicate`
and `_UnionGenericAlias.__eq__` no longer handle Union. The fix's mechanism
(tolerating unhashable args when deduplicating a Union) is the
`unhashable_args` fallback in `unionbuilder_add_single_unchecked`.

Change: in that function, when `PyObject_Hash(arg)` fails, propagate the
TypeError (return false) instead of clearing it and recording the arg in
`unhashable_args`. This reverses the fix hunks that added the
`try: dict.fromkeys / except TypeError` fallback in `_deduplicate` (with
`unhashable_fallback=True` from `_remove_dups_flatten`), i.e. pre-fix
`set(params)` raised TypeError for unhashable members. The fallback `__eq__`
path (`_compare_args_orderless`) is only reachable with unhashable args, so
it is dead once creation fails.

Failing oracle cases: `test_typing.UnionTests.test_union_of_unhashable`
(`Union[A, B]` raises `TypeError: unhashable type`) and the Annotated
`test_deduplicate_from_union` / `test_order_in_union` cases with unhashable
metadata (TypeError: unhashable type: 'dict'). 3 errors in test_typing.
