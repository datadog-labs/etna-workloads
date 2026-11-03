`repro.go` is the issue54722 test (G[T] containing H[G[T]]) plus a main that uses it.
Clean go1.27.3 compiles and runs it (prints 2). The buggy toolchain fails with
"internal compiler error: G[go.shape.int] is missing its underlying type", because
shapify asserts on a TFORW recursive instantiated type.
