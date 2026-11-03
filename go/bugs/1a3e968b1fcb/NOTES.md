repro.go is test/fixedbugs/issue24491a.go (includes the method-call case from the fix).
It does `defer s.test(..., uintptr(setup()), ...)` on a //go:uintptrescapes method.
Clean: exits 0. Buggy: the receiver/args aren't kept alive through the go/defer wrapper, so GC frees them and it panics "method call: p failed" (exit 2).
