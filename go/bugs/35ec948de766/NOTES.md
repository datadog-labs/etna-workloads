Reproducer: repro.sh builds a module with `go 1.17` containing a generic func assigned to a typed
func variable (`var v func(int) = f`), i.e. reverse type inference with no index expression.
Clean: reports "function instantiation requires go1.18 or later" at x.go:5:19.
Buggy: types2 dereferences the nil index expr and panics ("The following panic happened checking types near ./x.go:5:5"), missing that error.
