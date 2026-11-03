repro.go converts the constant "" to a type parameter T constrained by []byte | []rune, then instantiates it.
go-clean compiles and runs it, printing "ok" (exit 0).
go-buggy fails with `internal compiler error: invalid constant conversion to go.shape.[]uint8: ""` (exit 1). The injected assertion on ConvertVal is too strict for non-constant targets such as []byte and []rune.
Note: a shared GOCACHE can hide the difference, because the toolchains have the same build ID. My first two runs showed no difference until I used a fresh GOCACHE. check.sh did show the difference.
