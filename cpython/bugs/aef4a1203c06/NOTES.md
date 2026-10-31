repro.py: runs a coroutine that raises ZeroDivisionError in a `finally` while cancelled by `asyncio.timeout()`. It prints the type of the ZeroDivisionError's `__context__` and of that exception's `__cause__`.
Clean: the context is `TimeoutError`, caused by `CancelledError`.
Buggy: the context is the bare `CancelledError`, because `Timeout.__aexit__` no longer inserts the `TimeoutError` into foreign exceptions' context chain.
