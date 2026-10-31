Reproducer: start `agen.asend(None)`, advance it into an `await` that swallows GeneratorExit
and yields again, then call `.close()` on the asend awaitable.
Clean: prints `RuntimeError: coroutine ignored GeneratorExit`.
Buggy: close() is a stub that just marks the awaitable closed, so it prints `None`.
