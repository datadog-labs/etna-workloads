Reproducer: a memoryview obtained via `memoryview(b'abc').__buffer__(0)` (a second memoryview exporting from the first) is stored in a self-referential object, then collected by the GC.

Clean: prints `None` (exit 0). Buggy: memory_clear() clears `mbuf` even when the memoryview has exports, so the run aborts with `mbuf_dealloc: Assertion 'self->exports == 0' failed` (SIGABRT, status -6).
