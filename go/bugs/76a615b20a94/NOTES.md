`repro.go` is test/fixedbugs/issue24491a.go with the panics replaced by a printed `FAIL:` line and `os.Exit(1)`, so the output has no addresses.

It calls a `//go:uintptrescapes` variadic function through `go` and `defer`, passing `uintptr(unsafe.Pointer)` arguments in the `...uintptr` part. It then forces GC inside the callee, where a finalizer overwrites the pointed-to string.

- **clean:** the compiler flattens the variadic slice literal at the go/defer statement. The pointers stay alive until the call returns, so the program prints nothing and exits 0.
- **buggy:** the slice literal is captured whole, so the pointers inside it are not kept alive. The finalizer runs early and the program prints `FAIL: go: r[i] failed` and exits 1.

Use a separate GOCACHE per toolchain when testing by hand. A shared cache let a buggy build be reused by the clean toolchain and hid the difference.
