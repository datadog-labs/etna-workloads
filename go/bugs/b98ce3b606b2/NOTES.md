repro.sh builds a two-package module: package a exports an inlinable function returning a struct
containing an empty closure (`func() {}`), and main calls it and then calls the closure.
Clean toolchain: prints `true` and exits 0.
Buggy toolchain: the empty closure body is dropped on import, and the build fails with an internal
compiler error and write-barrier/escape errors in the runtime package, with exit status 1.
This matches the failure in test/fixedbugs/issue44330.go.
