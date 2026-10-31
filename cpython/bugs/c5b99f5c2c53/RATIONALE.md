# Rationale

Only implementation hunk of the fix: `Modules/_asynciomodule.c`, `future_schedule_callbacks`.

Reversed it directly in v3.15.2. The code that transfers ownership of `fut->fut_callbacks` to a local, iterates over it with a fixed `n`, and decrefs it at the end is replaced with the pre-fix code. The new code reads `len` once, iterates `fut->fut_callbacks` in place, and calls `Py_CLEAR(fut->fut_callbacks)` afterwards or on error. The empty-list early return is restored too.

The `fut_callback0` ownership-transfer code, which is a separate earlier fix, is left alone.

## Effect
An evil `call_soon` can shrink `fut->fut_callbacks` during iteration. `PyList_GET_ITEM` then reads out of bounds, or reads a NULL slot, and `PyTuple_GET_ITEM` on it crashes.

`./check.sh` shows the oracle run crashing. 184 of 189 cases are reported failing because the run is incomplete. `test_evil_call_soon_list_mutation` is among them.
