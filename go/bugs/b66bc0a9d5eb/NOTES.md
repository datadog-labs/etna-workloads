repro.go: a generic type N[A] with a generic method `func (r N[B]) m[X any](...)`, called
recursively from inside its own body (`r.m(x, b)`, where `r`'s type is the method's receiver type).

go-clean compiles and runs it (prints `s 3`, `1.5 3`, `7 3`).
go-buggy hits `internal compiler error: panic: .../types2/instantiate.go:159: assertion failed`.

Cause: the injected early return in Named.expandMethod returns the declared method (`return orig`)
when the receiver base is already `t`. For a generic method, that Func still has its own type
parameters, so the later instantiation asserts.
