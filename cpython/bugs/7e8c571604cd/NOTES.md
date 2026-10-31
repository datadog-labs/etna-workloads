Reproducer: `loop.call_soon_threadsafe()` should return an `events._ThreadSafeHandle` (a Handle with an RLock guarding cancel/_run). The injected bug removes it and uses a plain `Handle`.
Clean prints `_ThreadSafeHandle` / `True`; buggy prints `Handle` / `False`.
