# Rationale

The fix changed the error exit after `PyObject_IsTrue` in COMPARE_AND_BRANCH from
`goto error` to `ERROR_IF(err < 0, error)`. The original bug was a stack-cleanup mismatch: the
inputs had already been decref'd, but the error path cleaned them up again.

In v3.15.2 the fused compare-and-branch is `_COMPARE_OP` with the `oparg & 16` bool-conversion
path. It decrefs the inputs (`DECREF_INPUTS`), which also pops them, and then calls
`PyObject_IsTrue(res_o)`.

## Change
- `tree/Python/bytecodes.c`, `_COMPARE_OP`: the `ERROR_IF(res_bool < 0)` after the
  `PyObject_IsTrue` conversion is now `if (res_bool < 0) { goto pop_2_error; }`.
  The inputs are already closed and popped at that point, so `pop_2_error` pops and decref's them a second time.
  This is the same double-decref defect as the original.
- `tree/Python/generated_cases.c.h` and `tree/Python/executor_cases.c.h` were regenerated with
  `tier1_generator.py` and `tier2_generator.py`.

## Oracle
`test_interpreter_convert_to_bool_raises` fails: the interpreter crashes with a double decref and
a corrupt stack. The crash aborts the run, so the later tests in test_bool also show as failing.
