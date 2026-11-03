Reproducer: repro.go is the upstream test issue65417.go. It indexes a constant string with `unsafe.Sizeof(t)` (and `unsafe.Sizeof(t)+0`) where t has a type-parameter type.

Clean toolchain: compiles, and both calls panic with an index-out-of-range at run time (exit 0).
Buggy toolchain: compile error "invalid string index uintptr(1) (out of bounds for 1-byte string)" (exit 1). The size is not constant in generic code, so it should not be checked at compile time.
