# Rationale

Bug: GH-125789. The C `asyncio.Future._callbacks` getter could return the internal `fut_callbacks` list instead of a copy, so user code could mutate internal state.

## Change
`Modules/_asynciomodule.c`, `_asyncio_Future__callbacks_get_impl` (the getter was renamed and moved to clinic since the fix). I re-added the early return that the fix removed:

```c
if (self->fut_callback0 == NULL) {
    if (self->fut_callbacks == NULL) Py_RETURN_NONE;
    return Py_NewRef(self->fut_callbacks);
}
```

This reverses the fix hunk that deleted that block and merged the `callback0 == NULL` case into the copying path. When `fut_callback0` is NULL, the getter hands out the live internal list again. The rest of the function is the post-fix copying code, which still matches the old behaviour whenever `callback0` is set.

## Oracle
`CFutureTests.test_callbacks_copy` fails. After `remove_done_callback(f1)`, `fut_callback0` is NULL and `_callbacks` returns the same list object on each access. `assertIsNot(callbacks, fut._callbacks)` therefore fails with "unexpectedly identical".
The other 188 cases pass.
