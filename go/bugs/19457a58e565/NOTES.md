`repro.go` instantiates `g[T any](x T) interface{}` (which returns `x` as `interface{}`) with `T = interface{}`.
Inside the shaped function, the conversion T -> interface{} is an OCONVNOP between interfaces involving a shape type.
The injected bug drops the `!IsEmptyInterface()` check in reader.go, so that conversion is rewritten to OCONVIFACE with an empty-interface operand.

- go-clean: compiles and prints `true`, exit 0.
- go-buggy: `internal compiler error: OCONVIFACE can't operate on an empty interface`, exit 1.
