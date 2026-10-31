repro.py calls `bytearray.join` with a generator that clears the bytearray while being iterated (issue #112625).

- clean: join exports the bytearray, so `clear()` raises `BufferError: Existing exports of data: object cannot be re-sized`.
- buggy: no export protection, so `clear()` succeeds and join returns `bytearray(b'AB')`. The separator buffer was freed during the join, so this is also a use-after-free.
