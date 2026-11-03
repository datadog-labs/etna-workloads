repro.go: `var a, _ any = <-(chan int)(nil)` (comma-ok receive with an implicit int->any conversion).
go-clean compiles it; the program then deadlocks at init (receive on nil chan), a deterministic runtime fatal error.
go-buggy fails to compile: "internal compiler error: 'init': unhandled expr CONVIFACE", because walkAssignRecv doesn't walk the resulting assignment.
