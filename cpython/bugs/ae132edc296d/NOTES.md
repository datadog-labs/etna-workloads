repro.py calls `_warnings._release_lock()` without holding the warnings lock.
Clean: raises RuntimeError('cannot release un-acquired lock'), exit 0.
Buggy: unlocks unconditionally, so CPython aborts with a fatal error (exit -6).
