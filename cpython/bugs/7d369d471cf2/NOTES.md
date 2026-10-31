Calls `.throw(MyException)` twice on the same `aclose()` awaitable. Clean: the second throw
raises `RuntimeError: cannot reuse already awaited aclose()/athrow()`. Buggy: the awaitable
is not marked closed after the first throw fails, so the second throw raises MyException again.
