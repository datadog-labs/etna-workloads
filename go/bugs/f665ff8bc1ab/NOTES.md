repro.go is the issue78408 test (a label `A` reused inside a closure within a range-over-func loop that does `goto A`), plus a main.

Clean toolchain: compiles and runs, printing "ok".
Buggy toolchain: the compiler panics with an internal compiler error (index out of range in ssa.fuseBlockPlain). The rangefunc rewrite lets the nested closure's label overwrite the outer label's loop.
