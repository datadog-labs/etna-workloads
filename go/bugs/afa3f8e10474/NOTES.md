repro.go is the issue51913 test, printing b instead of panicking. An earlier initializer
(`var _ = func() int { a = false; ... }()`) reassigns `a` before `var b = a` runs.
Clean toolchain prints `b = false`. The buggy toolchain statically copies a's initial value
into b and prints `b = true`.
