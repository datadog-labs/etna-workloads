repro.sh compiles a benchmark with `for b.Loop()` containing `_ = f(1)`, `_, _ = g(1)` and `_, _ = f(1), f(2)`, using `-gcflags=-m=2`, and prints the "will be kept alive" diagnostics.

Clean: blank assignments are rewritten to temps, so the diagnostics name `command-line-arguments..autotmp_N`.
Buggy: the blank `_` is left in place, so the diagnostics say `_ will be kept alive`, and nothing real is kept alive. The result can be optimized away.
