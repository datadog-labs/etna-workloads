repro.go indexes a zero-length array of a non-SSAable struct type (`var arr [0]S; arr[i].n`).
Clean toolchain compiles it and the program panics with an index out of range (recovered).
Buggy toolchain hits an internal compiler error because the placeholder zeroVal of a non-SSAable type is returned (issue 77868).
