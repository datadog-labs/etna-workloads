Applies `warnings.deprecated` to a sync and an async function and prints `inspect.iscoroutinefunction` for each.
Clean: `False` then `True`. Buggy: `False` then `False` (wrapper loses coroutine status).
