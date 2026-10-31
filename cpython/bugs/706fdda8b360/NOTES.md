`bytes.hex(sep, bytes_per_sep)` with `bytes_per_sep = -sys.maxsize - 1` (-2**63).
Clean returns `'6162636465'`. The buggy build computes the absolute value with `Py_ABS`
into an `unsigned int`, which overflows to 0, so the later division by it raises SIGFPE
(`Fatal Python error: Floating-point exception`, killed by signal).
