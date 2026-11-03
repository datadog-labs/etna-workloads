repro.go is the upstream test issue79812.go: a generic func converts the constant 0+0i to a ~float64 type parameter, instantiated via bar(0, f[T]).
Clean toolchain: builds and runs, exit 0, no output.
Buggy toolchain: internal compiler error "weird float conversion complex128 -> go.shape.float64", exit 1.
