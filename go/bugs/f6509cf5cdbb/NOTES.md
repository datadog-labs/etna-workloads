repro.go is the issue64826 test program: f switches on len(x) with 8 dense cases (a jump table), and g(false) always returns "q", so len is constant 1.
SCCP constant-folds the jump table's index to an out-of-range value in unreachable code.
go-clean compiles and runs it with exit 0. go-buggy's compiler panics in ssa sccp rewireSuccessor (internal compiler error).
