Reproducer (repro.go): `unsafe.Sizeof(T1[T]{})` inside a generic function, where `type T1[T any] [42]T2[T]` and `type T2[T any] [42]T` (the issue77382 test case).

Clean toolchain: compiles and runs, printing 7056.
Buggy toolchain: internal compiler error, `gcsizes.go:154: assertion failed`, exit status 1.

Cause: hasVarSize inspects `fromRHS` without calling `Named.unpack()`, so an unexpanded instantiated type is wrongly treated as fixed-size.
