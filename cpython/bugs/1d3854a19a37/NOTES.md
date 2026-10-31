repro.py wraps a RawIOBase whose `closed` property calls `wrapper.detach()` (once) in a TextIOWrapper, then calls `wrapper.close()` (gh-142594).

- python-clean: close() notices the wrapper was detached and returns; prints `ok`, exit 0.
- python-buggy: the `self->detached` check in `_io_TextIOWrapper_close_impl` is missing, so close() carries on with the detached wrapper and raises `ValueError: underlying buffer has been detached` (exit 1). It did not crash or hit an assert in this build.
