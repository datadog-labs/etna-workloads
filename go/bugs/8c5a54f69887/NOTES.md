repro.sh compiles the issue61895 program (an infinite `for {}` followed by two
unreachable open-coded defers) directly with `go tool compile -p main`.

go-clean: compiles cleanly, exit 0.
go-buggy: internal compiler error "unexpected frame offset for open-coded defer
slot #1: have 1, want 8", exit 1.

`go build`/`go run` don't show the difference here, and `go run` would hang
in `for {}` anyway, so the script calls the compiler directly.
