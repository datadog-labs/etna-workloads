Reproducer: repro.go (upstream test/typeparam/issue52026.go). returnOption[T] converts Some[T]/None to the generic interface Option[T] inside a generic function.
Clean: compiles and runs, exit 0, no output. Buggy: internal compiler error "Option[go.shape.int] is a shape type" at repro.go:13:14, exit 1.
