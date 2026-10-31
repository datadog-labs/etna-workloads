Reproducer: opens a socketpair transport via asyncio, sets the write high-water mark to 1, and calls `writelines()` with 10 MB that cannot be fully sent. It prints whether the buffer is non-empty and whether the protocol's `pause_writing()` was called.

Clean: `True True`. Buggy: `True False` (the `_maybe_pause_protocol()` call in `_SelectorSocketTransport.writelines` is missing).
