Starts an async generator, then awaits `aclose()` on it, driving the coroutine by hand.
Clean: prints "closed" (then StopIteration). Buggy: `athrow.send()` in the INIT state raises RuntimeError, so aclose() fails.
