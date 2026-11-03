repro.go assigns an uninstantiated generic func `g` to func-typed targets (struct field, array/slice/map elements, conversion, channel send), including a type parameter `F func(int)`. The fix lets types2 infer the type arguments there.
go-clean compiles and prints "ok". go-buggy fails with "cannot use generic function g without instantiation" errors and exit status 1.
