Reproducer for gh-142554: it patches `_pylong.int_divmod` to return a 1-tuple, then calls `divmod(2**20000, 2**10000)`, which takes the `_pylong` path.

- Clean: prints `ValueError: tuple of length 2 is required from int_divmod()`.
- Buggy: the size check is missing, so `PyTuple_GET_ITEM(result, 1)` reads out of bounds. The interpreter segfaults (exit -11).
