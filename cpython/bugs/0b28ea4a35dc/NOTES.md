Reproducer for the pure-Python `Future.result()`/`exception()` refcycle bug.
It cancels an `asyncio.futures._PyFuture`, calls `result()`/`exception()`, catches the
`CancelledError`, and prints `len(gc.get_referrers(exc))`.
Clean prints 1 for each; buggy prints 2, because the `exc` local in the
method's frame creates a cycle (exc -> traceback -> frame -> exc).
