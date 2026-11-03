repro.go prints reflect's PkgPath() for unsafe.Pointer. Clean toolchain: `PkgPath="unsafe"`.
Buggy toolchain: typePkg treats unsafe.Pointer as a predeclared type, so the path is wrong (empty).
