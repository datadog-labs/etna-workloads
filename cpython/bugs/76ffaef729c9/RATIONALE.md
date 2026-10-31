# gh-128078 reintroduced

Hunks reversed (all still applied cleanly in v3.15.2, just at shifted lines):
- Objects/iterobject.c `anextawaitable_iternext`: removed `PyErr_Clear()` before `_PyGen_SetStopIterationValue(obj->default_value)`.
- Objects/iterobject.c `anextawaitable_proxy`: same removal.
- Objects/genobject.c `_PyGen_SetStopIterationValue`: removed the `assert(!PyErr_Occurred())` the fix added.

Effect: the StopAsyncIteration stays set while StopIteration(default) is built; with a tuple default, this gives
SystemError (and an assert abort in debug builds with the assert present; here the assert is removed too, as in the pre-fix code).

Oracle: test_async_gen_asyncio_anext_tuple_no_exceptions (and anext_tuple) fail; the test run was incomplete (crash), so the other listed cases show as failing too.
