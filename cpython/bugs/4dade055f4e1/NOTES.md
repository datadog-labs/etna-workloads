Exhausts an iterator over an empty array (which sets `it->ao` to NULL), then calls `__setstate__(0)`.
Clean: prints `StopIteration`. Buggy: `__setstate__` dereferences the NULL `ao` (debug build crash/segfault).
