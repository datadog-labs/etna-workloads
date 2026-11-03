repro.go is test/fixedbugs/issue65362.go (with the `// compile` line removed). It calls a method on a
recursive generic interface instantiation (VectorImpl[int].Diff(ReadVector[int])).
go-clean compiles and runs it with no output and exit 0. go-buggy fails with exit 1 and a bogus compile error:
"cannot use v2 (type ReadVector[int]) as type ReadVector[go.shape.int] ... wrong type for Diff method".
