`repro.py`: `bytearray.__setitem__` with an index object whose `__index__` clears and re-extends the bytearray (new buffer, same length).
Clean prints `63 True`; buggy prints `0 False` because the stale cached buffer pointer is written to (the write goes to freed memory/another object instead of the bytearray).
