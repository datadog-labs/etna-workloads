`repro.go` is the issue52529 case: a generic struct `Foo` refers to `Bar[P]`, `Bar` is defined as `Foo[Q]`, and `Bar` has a method that converts to `*Foo[R]`.

The clean toolchain compiles and runs it with exit status 0 and no output. The buggy toolchain checks field uniqueness during method collection, which expands the underlying type too early. It fails with `internal compiler error: panic: nil typ` and exit status 1.
