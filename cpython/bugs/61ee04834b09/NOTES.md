repro.py formats `bytearray(b"%a end") % S()` where `S.__repr__` clears the
bytearray while the `%`-formatting of `%a` is in progress.

- python-clean (fixed): `bytearray.__mod__` bumps `ob_exports` before calling
  the formatting code, so `fmt.clear()` inside `__repr__` sees an outstanding
  export and raises `BufferError: Existing exports of data: object cannot be
  re-sized`. That exception propagates out of `__mod__` and is caught and
  printed by repro.py.

- python-buggy (bug reintroduced): `ob_exports` is not incremented, so
  `clear()` is allowed to resize/free the bytearray's internal buffer while
  the formatting code still holds a raw pointer into it. The result is a
  used-after-free: no exception is raised, and `__mod__` returns a corrupted
  bytearray (uninitialized/stale heap bytes, `bytearray(b'E\xdd\xdd\xdd\xdd')`
  in this run) instead of failing safely.

`check.sh` shows both interpreters exit 0, but the printed result differs:
clean prints the `BufferError` message, buggy prints a corrupted bytearray
repr.
