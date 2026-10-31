`repro.py` builds `anext(A(), "a").__await__()` (an `anext_awaitable`) and calls `.close(1)`.

- Clean: `close` is `METH_NOARGS`, so it raises `TypeError` (prints `TypeError`).
- Buggy: `close` is `METH_VARARGS` and silently accepts the argument (prints `no error`).
