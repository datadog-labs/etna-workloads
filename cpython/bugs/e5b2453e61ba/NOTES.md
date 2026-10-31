Reproducer: ten coroutines concurrently await `FlowControlMixin._drain_helper()` while writing is paused, then `resume_writing` is called.
Clean: prints `10`. Buggy: only one drain waiter is stored, so the second drainer trips the `assert waiter is None or waiter.cancelled()` (AssertionError), and the earlier waiters are never woken.
