`repro.go` calls an inlinable function with a top-level function value (`receiver(argument)`) inside a `b.Loop()` body.
bloop keeps call arguments alive by taking their address. With the bug, the PFUNC name `argument` is no longer filtered out as non-addressable.
go-clean prints `true` and exits 0. go-buggy fails to compile with an ICE: "variable address class PFUNC not implemented".
