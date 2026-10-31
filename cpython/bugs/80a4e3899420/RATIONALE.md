# Rationale

Fix: gh-119821, support non-dict globals in LOAD_FROM_DICT_OR_GLOBALS.

In v3.15.2 the instruction's fallback calls the shared helper
`_PyEval_LoadGlobalStackRef`, which has the non-dict slow path that the fix added.
Reversing the hunks directly doesn't work, since the code has been refactored.

## Changes
- `Python/bytecodes.c` (`LOAD_FROM_DICT_OR_GLOBALS`): the helper call is replaced with the
  pre-fix lookup. That is `PyDict_GetItemRef(GLOBALS(), ...)`, then
  `PyMapping_GetOptionalItem(BUILTINS(), ...)`, then NameError. This reverses the
  `bytecodes.c` hunk, which added the `PyDict_CheckExact` fast path and the mapping slow path.
  `PyDict_GetItemRef` raises SystemError when globals is a dict subclass or other non-dict,
  or it bypasses `__missing__`.
- `Python/generated_cases.c.h`: regenerated with `tier1_generator.py`, which reverses the
  matching hunk.

The fix's other hunks (uop metadata, executor and optimizer cases) don't need reverting.
In v3.15.2 this instruction is still not a tier 2 uop.

## Oracle
`TypeParamsExoticGlobalsTest.test_exec_with_unusual_globals` fails with
`NameError: name 'undefined' is not defined`. The globals dict's `__missing__` is ignored.
The other 33 cases pass.
