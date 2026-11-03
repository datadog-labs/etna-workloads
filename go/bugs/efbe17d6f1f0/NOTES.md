repro.go is test/typeparam/issue52124.go made runnable (adds a main that prints the values).
It declares variables of type `interface{ any | int }`-style unions that are equivalent to `any`.
Clean toolchain: prints `42 xxx true`, exit 0.
Buggy toolchain: the reader no longer handles pkgbits.TypeUnion, so the compiler fails with
"internal compiler error: panic: unexpected type: 10", exit 1.
