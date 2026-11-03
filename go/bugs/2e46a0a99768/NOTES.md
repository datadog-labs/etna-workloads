repro.go is upstream test/typeparam/issue51522b.go: generic functions use `switch i { case t: }` and `switch t { case i: }` with a type-parameter value mixed with an interface value.
go-clean compiles and runs it silently (exit 0). go-buggy fails with an internal compiler error ("any is not assignable to T") at the second switch (exit 1).
