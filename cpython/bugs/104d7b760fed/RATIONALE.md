# Rationale

Fix gh-105340 made `locals()`/`vars()`/`dir()`/`eval()`/`exec()` include hidden fast-locals
(PEP 709 inlined-comprehension iteration variables) at module/class scope.
In v3.15.2 (PEP 667) this is done in `_PyFrame_GetLocals` (Objects/frameobject.c): for
non-optimized frames it returns `frame->f_locals` directly only when there are no hidden
locals (`!_PyFrame_HasHiddenLocals(frame)`); otherwise it returns a frame-locals proxy that includes them.

Change: dropped the `&& !_PyFrame_HasHiddenLocals(frame)` condition, so module/class frames
always return plain `f_locals`, which lacks hidden locals. This reverses the fix hunks that
added `include_hidden` handling in `_PyFrame_GetLocals` and the callers switched to
`_PyEval_GetFrameLocals` (all of which now go through this function), restoring the pre-fix result.

Failing oracle cases: `test_iter_var_available_in_locals` (scope='module' and 'class'):
`locals()["x"]` raises KeyError inside a comprehension.
