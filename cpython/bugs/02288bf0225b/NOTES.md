repro.py calls dict.clear() on an object's embedded `__dict__` while a value's `__del__` deletes another key from the same dict (re-entrant mutation during clear).

- Clean: prints `{} 0`, exit 0.
- Buggy: debug assertion failure in `_PyDict_CheckConsistency` (`ma_used` out of range), abort (exit -6).
