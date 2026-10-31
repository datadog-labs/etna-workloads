repro.py calls PyTraceMalloc_Track/Untrack via ctypes while tracemalloc is not tracing.
Clean: both return -2 (no-op). Buggy: the "not tracing" checks are gone, so
tracemalloc_add_trace_unlocked hits `assert(tracemalloc_config.tracing)` and aborts (SIGABRT).
