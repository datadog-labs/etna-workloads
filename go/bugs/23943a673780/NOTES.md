repro.go is test/fixedbugs/issue24491a.go. It does `defer s.test(..., uintptr(setup()), ...)` on a //go:uintptrescapes method.
Clean: exits 0 with no output. Buggy: the receiver isn't passed through the go/defer wrapper, so the unsafe-uintptr args aren't kept alive; the program panics with "method call: p failed" (exit 2).
