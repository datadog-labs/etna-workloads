repro.go is the issue42703 test: `f()()` calls a function whose callee expression has side effects (f sets ok[0]).
On the buggy toolchain the compiler drops the side effects of the callee expression when inlining, so the program panics with "FAIL" (exit 2). The clean toolchain prints "ok" and exits 0.
