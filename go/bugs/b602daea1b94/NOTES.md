repro.go calls a promoted pointer-receiver method (and takes a method value) through a
pointer to a struct that embeds another struct: `s := &A{}; s.Work()`.
The unified IR writer's recvExpr walks the implicit field path without dereferencing
the pointer first (injection removes `deref2`).

go-clean: prints "work" twice, exit 0.
go-buggy: internal compiler error "interface conversion: syntax.Type is *types2.Pointer,
not *types2.Struct", exit 1. With a cold build cache the crash is reported while compiling
`runtime` (which hits the same pattern); with a warm std cache it is reported for the
user's package (`go tool compile repro.go` shows it directly).
