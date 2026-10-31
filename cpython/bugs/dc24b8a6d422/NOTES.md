Passes a dialect object whose `__getattr__` raises RuntimeError to `csv.reader` / `csv.writer`.
Clean: RuntimeError("boom") propagates. Buggy: `_csv` dialect_new clears every exception from the
attribute lookup, so the error is swallowed and no exception is raised.
