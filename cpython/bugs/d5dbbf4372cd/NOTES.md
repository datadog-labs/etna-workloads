Cancels a pure-Python future (asyncio.futures._PyFuture), catches the CancelledError from `result()`, and prints the number of `gc.get_referrers` of the exception.
Clean prints 1; buggy prints 2, because the injected `exc = ...; raise exc` leaves a local `exc` in the frame, making a reference cycle (exception -> traceback -> frame -> exc).
