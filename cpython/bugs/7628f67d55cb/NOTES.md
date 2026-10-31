Reproducer: call a MagicMock's `__str__`/`__hash__`, then `reset_mock(return_value=True)`, and call them again.
Clean: both calls return str/int. Buggy: after reset the return values become MagicMock (magic defaults are wiped).
