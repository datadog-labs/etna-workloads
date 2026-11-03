`repro.go` declares `func g(x int, y float32) (...)`, a `...` result with no type.
Both toolchains fail to compile it, but the syntax error text differs.
- clean: `syntax error: ... is missing type`
- buggy: `syntax error: final argument in variadic function missing type`
