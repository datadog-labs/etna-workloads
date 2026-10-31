# Rationale

Changed `clear_lock_held` in `Objects/dictobject.c`, reversing the fix's single implementation hunk.

The fix made `dict.clear()` on a dict backed by embedded inline values clear the values in place and leave the dict attached (`oldvalues->size = 0`). In v3.15.2 that is the `else if (oldvalues->embedded) { clear_embedded_values(...) }` branch.

I removed that branch. Embedded values now go through the pre-fix path:
- The dict is detached: `set_values(mp, NULL)` and `set_keys(mp, Py_EMPTY_KEYS)`.
- The inline values are not cleared (`if (!oldvalues->embedded)` guards the clearing and `free_values`).
- The keys ref is dropped.

The object's inline values are therefore out of sync with its dict. A later `obj.foo = ...` hits an inconsistent state and aborts. This is the GH-117750 symptom.

## Oracle
`./check.sh` reports 13 of 42 cases failing in `Lib/test/test_class.py`, and the run is incomplete (crash or assert). `test_bug_117750` is among the failures. Most of the other failing cases are `TestInlineValues` tests, which I didn't investigate separately. They are probably collateral from the crash aborting the run.
