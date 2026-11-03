`repro.sh` compiles a loop `for idxA >= 0 && idxB >= 0` with two induction variables, using `-gcflags=-d=ssa/prove/debug=1`.
Clean toolchain: prove finds both induction variables and proves both `a[idxA]` and `b[idxB]` in bounds.
Buggy toolchain: only the first induction variable is found, and the `b[idxB]` bounds check is not proved, so it stays in the generated code.
This is a missed optimization, visible only in the prove diagnostics.
