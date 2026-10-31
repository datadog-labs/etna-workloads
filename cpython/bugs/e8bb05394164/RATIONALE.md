# Rationale

Fix hunk reversed (Objects/genobject.c, `_gen_throw`): the fix added frame linking
(`frame->previous = tstate->current_frame; tstate->current_frame = frame;` and the
restore afterwards) around the `throw()` call on a non-generator `yf` (custom iterator).
In v3.15.2 that code also has `_PyThreadState_UpdateLastProfiledFrame`; I removed the
whole link/unlink block in the `else` branch, leaving the bare
`PyObject_CallFunctionObjArgs(meth, typ, val, tb, NULL)` as before the fix. The
`tstate` hoisting in the fix is harmless and left as is (still used by the generator branch).

Failing oracle case: `GeneratorStackTraceTest.test_throw_with_yield_from_custom_generator`
fails with `['throw'] != ['throw', 'g']`: the outer generator frame is missing from the
stack when throwing into a custom (non-generator) iterator.
