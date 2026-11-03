repro.sh writes the issue56923 test program (generic Eq/EqFunc, package-level
`var Bytes Eq[[]byte] = New(Equal)`) and compiles it with `go tool compile`.
Clean: compiles, exit=0. Buggy (staticinit no longer rejects shape-typed
OCONVIFACE): "internal compiler error: shape types have no methods
p.EqFunc[go.shape.[]uint8]", exit=2.
(`go build` of the package showed no difference in my try, so the script uses `go tool compile`.)
