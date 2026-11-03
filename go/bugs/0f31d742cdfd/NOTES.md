`repro.go` calls `new(i > 0)`, where the argument is an untyped bool expression.

- go-clean: compiles and prints `ok`.
- go-buggy: internal compiler error, "bad conversion to untyped: untyped bool".

The injection removes the `typecheck.DefaultLit` call on the `new(expr)` operand in `noder/reader.go`, so the untyped value never gets a default type.
