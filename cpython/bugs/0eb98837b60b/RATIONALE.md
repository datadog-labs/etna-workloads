# Rationale

The fix (gh-109593) added `_recursion_count()` to `_thread.RLock` and `threading._RLock`.
It returns 0 when the lock is not owned by the calling thread. The resource tracker
uses it for reentrancy checks. That code has since been rewritten, so the tracker hunks
cannot be reverted cleanly. I restored the defect in the method itself.

- `Modules/_threadmodule.c`, `_thread_RLock__recursion_count_impl`: reverses the fix's
  `rlock_recursion_count` hunk, which only reports the count when the owner is the current
  thread. The check is now "mutex is locked" rather than "locked by the current thread".
  A lock held by another thread therefore reports `level + 1` instead of 0.
- `Lib/threading.py`, `_RLock._recursion_count`: reverses the fix's `if self._owner != get_ident(): return 0`.
  It now returns `self._count` unconditionally.

Effect: a reentrancy check would misfire when another thread holds the lock.

Oracle: `lock_tests.RLockTests.test_recursion_count` (run via test_threading) fails on the
last assertions. The other thread holds the lock, but the test expects 0 and gets 1.
