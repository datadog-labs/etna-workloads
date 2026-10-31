# Rationale

## Lib/unittest/mock.py (`_patch.__enter__`)
Reverses the fix's hunk: the original `Klass` selection is restored. `_is_async_obj(original)`
is evaluated unconditionally (before checking `new_callable`), so `patch(..., new_callable=...)`
again reads attributes of the patch target. `Klass = MagicMock` default and `_kwargs = {}`
are restored to their pre-fix placement.

On v3.15.2 this alone no longer fails: `_is_async_obj` -> `inspect.isawaitable` ->
`isinstance(obj, collections.abc.Awaitable)` was made tolerant of objects whose `__class__`
raises AttributeError (gh-153772), so the same bug was "fixed twice".

## Modules/_abc.c (`_abc__abc_instancecheck_impl`) and Lib/_py_abc.py (`__instancecheck__`)
Reverts that second path (gh-153772 fallback to `type(instance)`) to the previous
`instance.__class__` / `PyObject_GetAttr` that propagates AttributeError. This is the same
defect: an opaque proxy whose attribute access raises AttributeError breaks isinstance
against ABCs, which is how mock's read of the original blew up.

## Oracle
`PatchTest.test_patch_proxy_object` fails with AttributeError (raised from
`OpaqueProxy.__getattribute__` via `isinstance(..., Awaitable)` in `_is_async_obj`).
