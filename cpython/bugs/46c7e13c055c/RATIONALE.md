# gh-129185 re-injection (Python/tracemalloc.c only)

In v3.15.2 the fix's pylifecycle.c ordering is already absent (`_PyTraceMalloc_Fini()` is still called early, before
`finalize_interp_clear()`), and the tables lock is a PyMutex, so a verbatim reversal does nothing. Instead I removed
the guards that the fix's hunks in `PyTraceMalloc_Track/Untrack` provide for calls made after `_PyTraceMalloc_Fini()`.

Changes (`Python/tracemalloc.c`):
- `PyTraceMalloc_Track` / `PyTraceMalloc_Untrack`: removed the `tracing == 0` early return ("check before
  TABLES_LOCK() to support calls after _PyTraceMalloc_Fini()", fix hunks 1-2 of tracemalloc.c).
- Also removed the in-lock `if (tracemalloc_config.tracing)` fallback (-2) in both, which is the other path
  that covered the same case. Track/Untrack now touch the hash tables unconditionally, even after
  tracemalloc was stopped or `_PyTraceMalloc_Fini()` destroyed them (the fix's reported crash: calling
  Track/Untrack in late finalization from an object destructor).

Oracle: with the guard gone, `tracemalloc_remove_trace_unlocked`'s `assert(tracemalloc_config.tracing)` aborts
(debug build) on untrack after stop / late untrack (test_stop_untrack, test_late_untrack, test_stop_track); the
crash aborts the test process, so the whole test_tracemalloc run is reported as failing.
