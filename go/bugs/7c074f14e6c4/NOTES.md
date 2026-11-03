repro.go is test/fixedbugs/issue79762.go (file name changed to repro.go; line numbers unchanged).
It triggers nil-pointer panics in f1/f2 and checks that the stack trace attributes the fault to
the caller's line (nil check position) rather than the inlined callee store (foo/setX).
Clean: no output. Buggy: prints stacks and "ERROR: stack contains foo/setX" because the
nilcheck position is not used when merged with a store (injection in nilcheckelim2).
