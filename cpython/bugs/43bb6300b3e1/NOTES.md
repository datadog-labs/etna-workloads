repro.py: a coroutine creates an object whose `__del__` runs a generator expression. The object is freed while the coroutine's frame is cleared on return, so a generator runs inside `clear_gen_frame`. The script then calls `coro().send(None)` and prints the `StopIteration` value.

- clean: prints `result 42`.
- buggy: prints nothing and exits 0. The nested generator overwrites `generator_return_kind`, so the coroutine's return is treated as a yield. `send()` returns normally and `StopIteration` is never raised.

The buggy interpreter did not hit an assert in this run.
