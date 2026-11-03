repro.go is test/fixedbugs/issue74379.go. `crashOnErr(err)` returns a constant false, and escape analysis rewrites the OCONVIFACE operand to a literal. The buggy compiler drops the call's side effect, which is the panic.
- go-clean: the call panics and the program exits 0 with no output.
- go-buggy: it prints "false" and "failed to have expected panic", then exits 1.
