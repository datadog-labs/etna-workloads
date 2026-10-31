# Rationale

Fix (gh-132744) added `_CHECK_RECURSION_REMAINING` to `CALL_PY_GENERAL` and
`CALL_BOUND_METHOD_GENERAL` (previously the recursion check lived only in
`_CHECK_STACK_SPACE`, which those macros don't use).

## Changes

- `Python/bytecodes.c`: removed `_CHECK_RECURSION_REMAINING` from the
  `CALL_PY_GENERAL` and `CALL_BOUND_METHOD_GENERAL` macros. This reverses the
  first two bytecodes.c hunks of the fix (the other hunks only touch
  exact-args macros, which still have the check in v3.15.2, and the op split
  that is already present).
- Regenerated `Python/generated_cases.c.h`, `Python/executor_cases.c.h`,
  `Python/optimizer_cases.c.h`, `Include/internal/pycore_opcode_metadata.h`,
  `Include/internal/pycore_uop_metadata.h`, `Lib/_opcode_metadata.py` with the
  cases generator scripts (equivalent of the fix's generated-file hunks).

## Oracle

`test_opcache.TestCallCache.test_recursion_check_for_general_calls` fails:
without the check, specialized general Python calls never hit the recursion
limit, so the interpreter crashes (stack overflow; the run is reported as
incomplete, which also takes down the other cases in the file).
