# Rationale

Fix hunk reversed: `Lib/_pylong.py` `int_to_decimal_string` (and the `_decimal` import
that only served it). v3.15.2 had the fix's fallback algorithm (compute_powers-based
`inner`, plus the >450_000-bit / C-decimal switch); I restored the pre-fix body
`return str(int_to_decimal(n))` and removed the `try: import _decimal` block.
This is the exact pre-fix code, so every int->str conversion goes through `decimal`,
and with the pure-Python `_pydecimal` this loops back into `str(int)` -> `_pylong`.

The fix's other hunks are tests/NEWS and were not touched.

Oracle: 7 errors in test_int (PyLongModuleTests.test_pylong_int_to_decimal etc. and
related int->str cases) fail with `RecursionError: maximum recursion depth exceeded`
in `int_to_decimal.inner`, the infinite mutual recursion the fix describes.
