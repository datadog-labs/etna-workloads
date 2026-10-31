# Rationale

Fix (gh-88834): `typing.Union.__instancecheck__` used to delegate to the
subclass check of `type(obj)`; the fix made it use `isinstance(obj, arg)`
for each argument. In v3.15.2 `Union` is the C `types.UnionType`, and
`isinstance(x, union)` is handled in `object_recursive_isinstance`
(Objects/abstract.c), which iterates the union args with isinstance.

Change: in that function, the union branch now loops over the args calling
`PyObject_IsSubclass(type(inst), arg)` — the pre-fix semantics
(`__instancecheck__` == `__subclasscheck__(type(obj))`). The tuple branch is untouched.

Failing oracle cases (test_typing.UnionTests): `test_union_isinstance_type_error`
and one more (the Optional variant). `isinstance(42, Union[str, Any])` no longer raises
TypeError because `issubclass(int, Any)` is true.
