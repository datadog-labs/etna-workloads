Reproducer: repro.go (the issue66585 test, printing values instead of panicking).
`foo()` does `x++` (an OASOP) on a global; the static initializer for `b = x` should see
the modified x. The buggy compiler's mayModifyPkgVar misses OASOP, so `b` is statically
initialized to 0.
clean: `a = 1 b = 1`; buggy: `a = 1 b = 0`.
