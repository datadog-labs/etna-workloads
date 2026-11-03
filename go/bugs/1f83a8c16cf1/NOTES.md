repro.sh compiles `func (a *A) Get(i int) byte { return a[i] }` with `type A [0]byte` using `-gcflags=-B` (bounds checks off).
Clean toolchain: compiles, exit 0. Buggy toolchain: internal compiler error "not lowered: v13, Unknown UINT8", exit 1.
Cause: indexing a zero-length array yields an OpUnknown value that is never lowered when bounds checks are disabled.
