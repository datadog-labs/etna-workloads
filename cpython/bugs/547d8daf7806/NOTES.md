Reproducer: store a `str`-subclass key equal to an existing key into an instance's split-table `__dict__`.
Clean: prints `2`. Buggy: assertion failure `!_PyDict_HasSplitTable(mp)` in insertdict (abort).
