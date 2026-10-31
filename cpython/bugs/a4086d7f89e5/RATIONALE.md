# Rationale: gh-142829, use-after-free in `Context.__eq__`

## Hunks reverted

1. `Python/hamt.c`, `_PyHamt_Eq`. This reverses the entire fix hunk in
   `hamt.c`. I removed the `Py_INCREF(v)`/`Py_INCREF(w)` pin taken on both
   HAMT objects at the top of the function, the temporary
   `Py_INCREF`/`Py_DECREF` of `v_key`, `v_val` and `w_val` around the
   `PyObject_RichCompareBool` call, and the `res`/`goto done` cleanup path.
   The function now again returns directly (`return -1`, `return 0`,
   `return 1`) from inside the loop, exactly as before the fix. Without the
   extra references, if the user-defined `__eq__`/`__hash__` invoked by
   `PyObject_RichCompareBool` re-enters and calls `ContextVar.set`, the HAMT
   nodes (or `v_val`/`w_val`) being iterated can be mutated/freed while the
   iterator still holds raw pointers into them, producing a use-after-free.

2. `Python/context.c`, `context_tp_richcompare`. The fix patch itself has no
   hunk in this file, but in v3.15.2 `context_tp_richcompare` independently
   takes strong references to both contexts' HAMTs via `context_get_vars()`
   before calling `_PyHamt_Eq`, and drops them afterwards. That extra
   reference-holding is the same fix for the same defect, applied a second
   time at the caller instead of the callee, and it alone is sufficient to
   keep the HAMTs alive across the reentrant callback — which is why
   reverting only the `hamt.c` hunk left every oracle case passing. I
   reverted this path too: `v_vars`/`w_vars` now simply borrow
   `ctx->ctx_vars` directly (no `Py_INCREF`/`Py_DECREF`), matching the
   pre-fix behaviour where nothing outside `_PyHamt_Eq` protected the
   compared HAMTs.

Both changes trace directly to the "hamt.c" hunk of `fix.patch`: hunk (1) is
its literal reversal, and hunk (2) reverts the equivalent protection that
the same codebase had grown at the call site, covering the same reentrancy
hazard through another path (per task step 4).

## Oracle result

`./check.sh` now reports for `Lib/test/test_context.py`: 56 of 57 oracle
cases failing, with the run ending in a crash (use-after-free / freed-memory
access caught by the debug build) inside the reentrant-equality test. The
two cases the fix's tests specifically added —
`test_context_eq_reentrant_contextvar_set` and
`test_context_eq_reentrant_contextvar_set_in_hash` — are both among the
failing/crashing cases, which is exactly the scenario the fix's tests guard
against: a custom `__eq__`/`__hash__` that re-enters `ContextVar.set` while
`Context.__eq__` is iterating the HAMTs.
