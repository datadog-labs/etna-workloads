Assigns a generic struct value (`fooer1[T]{}`, a derived type) to a non-name
destination of derived interface type (`g.r[0]` of type `Fooer[T]`) inside a
generic function, instantiated with `int` and `MyInt`.

go-clean compiles and prints `main.fooer1[int]` / `main.fooer1[main.MyInt]`.
go-buggy omits the implicit conversion in the unified IR writer and the
compiler crashes with `internal compiler error: incomplete itab`.
Note: if the toolchains share a GOCACHE, a stale cache entry can hide the bug.
