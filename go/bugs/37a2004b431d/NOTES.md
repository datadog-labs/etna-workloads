repro.sh compiles package a (func returning `interface{ Stop() }`) and a main package that
returns the method value `a.Start().Stop`, using `go tool compile` directly (as the test
harness does; `go build` did not trigger it).
go-clean compiles fine (exit 0). go-buggy hits the strict `n.Selection == wrapperFn.Selection`
assertion in noder/reader.go and fails with "internal compiler error: assertion failed" (exit 2).
