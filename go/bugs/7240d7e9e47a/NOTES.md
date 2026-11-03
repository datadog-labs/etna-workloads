repro.go is test/typeparam/issue52124.go (package main plus a main func). It declares union-constraint interfaces, including a cyclic one (A/B), and uses them as value types.
Clean toolchain: compiles and prints "ok". Buggy toolchain: the reader's re-enabled "impure type set" consistency check calls base.Fatalf, so the compiler crashes with an internal error.
