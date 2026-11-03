repro.go is test/fixedbugs/issue71675.go. It uses recover() inside defers registered in range-over-func loops, including a function whose return block is dead-code eliminated by a panic.
Clean: prints the expected sequence (f/g/h/i returned) and exits 0. Buggy: recovery from deferrangefunc defers jumps to a wrong PC and the program crashes with a runtime fatal error.
