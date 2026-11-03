repro.go is test/fixedbugs/issue78314.go: it ranges over a `func(func(int, ...string) bool)` value (variadic yield function).
go-clean rejects it: "cannot range over ... yield func of type func(int, ...string) bool cannot be variadic" (exit 1).
go-buggy lacks the `cb.Variadic()` check in types2 rangeKeyVal, so it compiles silently (exit 0).
