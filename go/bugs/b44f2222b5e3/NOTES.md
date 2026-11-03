repro.go instantiates `f[P interface{ m(R) }, R any]` with only P given (`f[T]`, T has `m(int)`).
The constraint has no core type, so R can only be inferred by unifying P's methods with the constraint's.
Clean toolchain: compiles and prints "ok". Buggy toolchain: compile error "cannot infer R" (issue 51593).
