# Rationale

Hunk changed: `Objects/genobject.c`, `gen_close()`, the `FRAME_CREATED` branch.
I removed the `gen_clear_frame(gen);` call. This reverses the fix's single
implementation hunk, which added `gen_clear_frame(gen)` there. In v3.15.2 the
state is set to `FRAME_CLEARED` through `_Py_GEN_TRY_SET_FRAME_STATE`, so
removing the call restores the old behaviour: the state changes but the frame
(and its locals/arguments) is not released.

Oracle failure: `GeneratorTest.test_close_clears_frame` fails with
`AssertionError: False is not true`. The `__del__` of the argument of a
never-started generator does not run when `close()` is called.
