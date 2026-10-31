# gh-141370: Py_ABS() undefined behaviour / truncation

Fix hunks reversed (the `_Py_ABS_CAST` macro in Include/pymacro.h is left defined, since it is harmless unused):

1. `Python/pystrhex.c` (`_Py_strhex_impl`): fix replaced `unsigned int abs_bytes_per_sep = Py_ABS(bytes_per_sep_group)`
   with `_Py_ABS_CAST(...)`. In v3.15.2 the variable was already `size_t`; restored the old
   `unsigned int abs_bytes_per_sep = Py_ABS(bytes_per_sep_group);`. `bytes_per_sep_group` is `Py_ssize_t`, so the
   value is truncated to 32 bits: e.g. `bytes_per_sep=2**32` becomes 0 and `(arglen - 1) / abs_bytes_per_sep`
   divides by zero (SIGFPE); `2**31`/`-2**31`-style values are also mishandled.
2. `Python/marshal.c` (`w_PyLong`): restored `uint64_t abs_value = Py_ABS(long_export.value);`
   (signed-overflow UB for INT64_MIN).

Oracle failures: `test_bytes ... test_hex_separator_basics` and `test_memoryview.OtherTest.test_memoryview_hex_separator`
crash the interpreter with a division by zero (SIGFPE) on `hex(':', 2**1000...)`-sized separators, aborting the rest
of the run. The marshal change is only UB (no failure without UBSan).
