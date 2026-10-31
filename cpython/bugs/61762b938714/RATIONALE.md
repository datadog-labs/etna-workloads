# Rationale

Fix GH-100126 made C code skip incomplete (shim/entry) frames by routing
`tstate->cframe->current_frame` reads through `_PyThreadState_GetFrame()`.
In v3.15.2 the helper and most call sites already exist, so I reverted the
globals/locals call sites in `Python/ceval.c` to read `tstate->current_frame`
directly (the pre-fix code):

- `PyEval_GetLocals`  (fix hunk: `PyEval_GetLocals`)
- `_PyEval_GetGlobals` (fix hunk: `PyEval_GetGlobals`, now split into a helper)

I did not revert `_PyEval_GetBuiltins`: that breaks the bootstrap build
(shim frame has NULL f_builtins), so the build fails before any test runs.
`_PyEval_GetFrame` is left alone for the same reason.

## Oracle failures
In `Lib/test/test_frame.py`, `test_entry_frames_are_invisible_during_teardown`
fails/crashes (exec() in the weakref callback reads globals/locals off the
shim frame), as do `test_issue95818` and `test_sneaky_frame_object_teardown`.
